{
  config,
  myEnv,
  secrets,
  lib,
  pkgs,
  remoteFiles,
  ...
}:
with myEnv;
{
  home.packages = with pkgs; [
    nufmt
  ];
  programs.fish.enable = true; # I may use fish completer in nushell
  programs.nushell =
    let
      p = pkgs.pinnedUnstables."2025-04-20";
    in
    {
      enable = true;
      package = p.nushell;
      plugins = with p.nushellPlugins; [
        skim
        polars
      ];
      # check options in https://github.com/nushell/nushell/blob/main/crates/nu-utils/src/sample_config/default_config.nu
      configFile.text =
        let
          nuHooks = "${remoteFiles.nuScripts}/nu-hooks/nu-hooks";
          task = "${remoteFiles.nuScripts}/modules/background_task/task.nu";
        in
        ''
          let carapace_completer = {|spans: list<string>|
              carapace $spans.0 nushell ...$spans
              | from json
              | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
          }

          let zoxide_completer = {|spans|
              $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
          }

          # This completer will use carapace by default
          let external_completer = {|spans|
              let expanded_alias = scope aliases
              | where name == $spans.0
              | get -i 0.expansion

              let spans = if $expanded_alias != null {
                  $spans
                  | skip 1
                  | prepend ($expanded_alias | split row ' ' | take 1)
              } else {
                  $spans
              }

              match $spans.0 {
                  # use zoxide completions for zoxide commands
                  __zoxide_z | __zoxide_zi => $zoxide_completer
                  _ => $carapace_completer
              } | do $in $spans
          }

          $env.config = {
             show_banner: false
             render_right_prompt_on_last_line: false
             history: {
                 sync_on_enter: false 
                 file_format: "sqlite"
                 isolation: true
             }
             completions: {
                 external: {
                     enable: true
                     completer: $external_completer
                 }
             }
          }
          $env.config = ($env.config | upsert hooks {
              env_change: {
                  PWD: [
                      {
                        condition: {|_, after| $after | path join 'init.nu' | path exists}
                        code: "print 'loading init.nu ...'; use init.nu *"
                      }
                  ]
              }
          })

          $env.config.hooks.env_change.PWD = (
               $env.config.hooks.env_change.PWD | append (source ${nuHooks}/direnv/config.nu)
          )

          use ${task}
          use std/dirs shells-aliases *
          def create [p: string] {            
              let full = $p | path expand
              mkdir ($full | path dirname) 
              touch $full
          }

          def r [] {            
             if (which direnv | is-not-empty) {
                 direnv export json | from json | default {} | load-env
                 if (which nix-direnv-reload | is-not-empty) {
                    nix-direnv-reload
                 }                  
             }
             nu
          }

          def shorten [
              input_path: path
              --offset (-o): int = 0
              --limit (-l): int = 10000
          ] {
              let output_path = ($input_path | path parse | upsert extension { || $"($offset)_($offset + $limit).short.($in)" } | path join)
              open $input_path --raw | lines | skip $offset | first $limit | to text | save -f $output_path
          }

          def "from ndjson" [] { from json -o }

          def filter-lines [
            input_file: path,    # The input file path
            search_string: string # The string to search for in each line
          ] {
            # Parse the input filename to get stem and extension
            let parts = $input_file | path parse

            # Construct the output filename like name.filtered.ext
            let output_file = $"($parts.stem).filtered.($parts.extension)"

            # Open the file, split into lines, filter, and save
            open $input_file
            | lines
            | where { |line| $line | str contains $search_string }
            | save $output_file

            print $"Filtered content saved to: ($output_file)"
          }

          def sync_videos [] {
              echo "Sync videos from Mac to Desktop"
              rsync -PamAXvtu -e ssh ${homeDir}/Downloads/videos/rsync weiss@${secrets.nodes.desktop.localIp}:/home/weiss/Downloads/videos/ 
              echo "Sync videos from Desktop to Mac"
              rsync -PamAXvtu -e ssh weiss@${secrets.nodes.desktop.localIp}:/home/weiss/Downloads/videos/rsync ${homeDir}/Downloads/videos/ 
          }
        '';
    };
}
