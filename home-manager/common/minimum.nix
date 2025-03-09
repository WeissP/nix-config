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
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home = {
    keyboard.layout = "de";
    stateVersion = "23.05";
    username = username;
    homeDirectory = homeDir;
    packages = [ pkgs.lsof ];
  };

}
