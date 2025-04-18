{ config, myEnv, secrets, lib, pkgs, ... }:
with myEnv; {
  programs = {
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        scan_timeout = 20;
        shell = {
          disabled = false;
          zsh_indicator = "𝒛𝒔𝒉>>>";
          bash_indicator = "𝒃𝒂𝒔𝒉>>>";
          nu_indicator = "𝒏𝒖>>>";
          style = "cyan";
        };
        character = {
          # success_symbol = "[λ](bold green) ";
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
        battery.display = [{
          threshold = 80;
          style = "bold red";
        }];
      };
    };
  };
}
