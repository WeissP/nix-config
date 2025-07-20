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
    bat.enable = true;
    atuin = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        search_mode = "fulltext";
        auto_sync = true;
        history_filter = [ "ai-config-upsert-provider" ];
        store_failed = false;
        score_exits = false;
      };
    };
    carapace = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = false; # I am using multiple completors
    };
    broot = {
      enable = false;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = false; # outdated
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      # have to do it on my own to make sure the completer work
      enableNushellIntegration = false;
    };
    thefuck = {
      enable = false;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
    autojump = {
      enable = false;
      enableZshIntegration = true;
    };
    fzf.enable = true;
    jq.enable = false;
  };
  services.gpg-agent = {
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
