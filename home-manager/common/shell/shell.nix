{ config, myEnv, secrets, lib, pkgs, ... }:
with myEnv; {
  programs = {
    bat.enable = true;
    autojump = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf.enable = true;
    jq.enable = true;

    zsh = lib.mkMerge [
      {
        enable = true;

        syntaxHighlighting.enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        autocd = true;
        historySubstringSearch.enable = true;
        history = {
          expireDuplicatesFirst = true;
          ignoreDups = true;
          size = 50000;
        };
        zplug = {
          enable = true;
          plugins = [
            { name = "ael-code/zsh-colored-man-pages"; }
            { name = "le0me55i/zsh-extract"; }
            { name = "hlissner/zsh-autopair"; }
            { name = "greymd/docker-zsh-completion"; }
            { name = "trystan2k/zsh-tab-title"; }
            { name = "le0me55i/zsh-systemd"; }
            { name = "hcgraf/zsh-sudo"; }
            {
              name = "akash329d/zsh-alias-finder";
              tags = [ "defer:1" ];
            }
          ];
        };
      }
      (ifDarwin {
        initExtra = ''
          sync_videos () {
              echo "Sync videos from Mac to Desktop"
          rsync -PamAXvtu -e ssh ${homeDir}/Downloads/videos/rsync weiss@${secrets.nodes.Desktop.localIp}:/home/weiss/Downloads/videos/ 
              echo "Sync videos from Desktop to Mac"
          rsync -PamAXvtu -e ssh weiss@${secrets.nodes.Desktop.localIp}:/home/weiss/Downloads/videos/rsync ${homeDir}/Downloads/videos/ 
          }
        '';
      })
    ];

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
