{ config, myEnv, secrets, lib, pkgs, ... }:
with myEnv; {
  programs = {
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        scan_timeout = 20;
        character = {
          success_symbol = "[λ](bold green) ";
          error_symbol = "[λ](bold red) ";
        };
        git_status = {
          conflicted = "conflicted×\${count}(red) ";
          ahead = "ahead ×\${count}";
          behind = "behind×\${count} ";
          diverged = "🔱 🏎️ 💨 ×\${ahead_count} 🐢 ×\${behind_count} ";
          untracked = "untracked×\${count} ";
          stashed = "stashed ";
          modified = "📝×\${count} ";
          staged = "staged×\${count} ";
          renamed = "renamed×\${count} ";
          deleted = "deleted×\${count} ";
          style = "bright-white ";
          format = "$all_status$ahead_behind";
        };
        battery.display = [{
          threshold = 80;
          style = "bold red";
        }];
      };
    };
  };
}
