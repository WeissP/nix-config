{ pkgs, lib, myEnv, config, secrets, inputs, outputs, ... }:
with myEnv; {
  imports =
    [ ./terminal/wezterm.nix ./shell.nix ./aliases.nix ./webman.nix ./emacs ];

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userEmail = secrets.email."163";
      userName = "weiss";
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
    packages = with pkgs; [ yt-dlp lux ];
  };

  home.file = let configDir = config.xdg.configHome;
  in {
    "${configDir}/wezterm" = {
      source = ./config_files/wezterm;
      recursive = true;
    };
  };

}
