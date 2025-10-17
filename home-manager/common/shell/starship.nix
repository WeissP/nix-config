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
  programs = {
    starship = {
      enable = true;
      settings =
        let
          headerColor = "#b4befe";
        in
        {
          # format = "↑$time$line_break$all$line_break";
          format = lib.concatStringsSep "$line_break" [
            # "[](${headerColor}) $shell [](${headerColor}) $os $time $character $cmd_duration"
            "[░▒▓](${headerColor})$shell[](${headerColor}) $os $time $cmd_duration $character"
            # "[░▒▓](#a3aed2)[  ](bg:#a3aed2 fg:#090c0c)[](bg:#769ff0 fg:#a3aed2)$shell[](fg:#769ff0 bg:#394260)"
            # "[░▒▓](#a3aed2) $shell [ ](bg:#769ff0 fg:#1d2230)$time[ ](fg:#1d2230) $character $cmd_duration"
            # '' $time $cmd_duration''
            ''$jobs$battery$status$container$netns$username$hostname$localip$shlvl$singularity$kubernetes$directory$vcsh$fossil_branch$fossil_metrics$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package$c$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$gleam$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$quarto$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$typst$vlang$vagrant$zig$buf$nix_shell$conda$meson$spack$memory_usage$aws$gcloud$openstack$azure$nats$direnv$env_var$mise$crystal$custom$sudo''
            "[](bold cyan) "
          ];
          add_newline = true;
          scan_timeout = 20;
          os = {
            disabled = false;
            # style = "bg:${headerColor}";
          };
          shell = {
            disabled = false;
            format = "[$indicator]($style)";
            zsh_indicator = ''𝒛𝒔𝒉'';
            bash_indicator = ''𝒃𝒂𝒔𝒉'';
            # nu_indicator = ''𝒏𝒖'';
            nu_indicator = '' Nushell '';
            style = "bg:${headerColor} fg:#090c0c bold";
          };
          character = {
            # success_symbol = "[λ](bold green) ";
            # success_symbol = "[](green)";
            success_symbol = "";
            error_symbol = "[](red) ";
          };
          git_status = {
            conflicted = "[🏳](red)";
            ahead = "⇡\${count}";
            diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
            behind = "⇣\${count}";
            modified = "📝×\${count}";
            style = "purple";
            format = "$conflicted [$modified]($style) [$ahead_behind]($style) ";
          };
          cmd_duration = {
            show_notifications = true;
          };
          time = {
            format = ''[$time]($style)'';
            disabled = false;
            style = "fg:${headerColor}";
          };
          fill = {
            symbol = " ";
          };
          nix_shell = {
            format = "via [$name]($style)";
            impure_msg = "";
            pure_msg = "";
          };
          battery.display = [
            {
              threshold = 80;
              style = "bold red";
            }
          ];
        };
    };
  };
}
