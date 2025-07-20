{
  pkgs,
  lib,
  myEnv,
  config,
  secrets,
  inputs,
  outputs,
  ...
}:
with myEnv;
{
  imports = [ ];

  nix.gc = {
    automatic = true;
    frequency = "daily";
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userEmail = secrets.email."163";
      userName = "weiss";
      extraConfig = {
        github = {
          user = "WeissP";
        };
      };
    };
    htop.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home = {
    keyboard.layout = "de";
    stateVersion = "23.05";
    username = username;
    homeDirectory = homeDir;
    packages = with pkgs; [
      lsof
      gtrash
      git-crypt
      additions.notify
    ];
    sessionPath = [
      scriptsDir
    ];
    sessionVariables = {
      SCRIPTS_DIR = myEnv.scriptsDir;
      RASP_IP = secrets.nodes.RaspberryPi.localIp;
      HOME_SERVER_IP = secrets.nodes.homeServer.localIp;
      DESKTOP_IP = secrets.nodes.desktop.localIp;
    };
    file = {
      "${homeDir}/scripts" = {
        source = ./config_files/scripts;
        recursive = true;
      };
    };
  };

}
