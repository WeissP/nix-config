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
          enable = false;
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
    ];
  };
}
