{ config, myEnv, secrets, lib, pkgs, ... }:
with myEnv; {
  programs = {
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
  };
}
