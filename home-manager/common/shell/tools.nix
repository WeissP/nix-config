{ config, myEnv, secrets, lib, pkgs, ... }:
with myEnv; {
  programs = {
    bat.enable = false;
    atuin = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      flags = [ "--disable-up-arrow" ];
      settings = { auto_sync = false; };
    };
    broot = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
    thefuck = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
    autojump = {
      enable = false;
      enableZshIntegration = true;
    };
    fzf.enable = true;
    jq.enable = true;
  };
  services.gpg-agent = {
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
