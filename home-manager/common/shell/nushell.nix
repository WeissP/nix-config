{
  config,
  myEnv,
  secrets,
  lib,
  pkgs,
  ...
}:
with myEnv;
{
  home.packages = [ pkgs.nufmt ];
  programs.fish.enable = true; # I use fish completer in nushell
  programs.nushell = lib.mkMerge [
    {
      enable = true;
      # check options in https://github.com/nushell/nushell/blob/main/crates/nu-utils/src/sample_config/default_config.nu
      configFile.text = ''
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

        use task.nu
        use std/dirs shells-aliases *
        def create [p: string] {            
            let full = $p | path expand
            mkdir ($full | path dirname) 
            touch $full
        }

        def sync_videos [] {
            echo "Sync videos from Mac to Desktop"
            rsync -PamAXvtu -e ssh ${homeDir}/Downloads/videos/rsync weiss@${secrets.nodes.Desktop.localIp}:/home/weiss/Downloads/videos/ 
            echo "Sync videos from Desktop to Mac"
            rsync -PamAXvtu -e ssh weiss@${secrets.nodes.Desktop.localIp}:/home/weiss/Downloads/videos/rsync ${homeDir}/Downloads/videos/ 
        }
      '';
    }
  ];
}
