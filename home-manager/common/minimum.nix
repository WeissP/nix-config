{ pkgs, lib, myEnv, config, inputs, outputs, ... }:
with myEnv; {
  imports =
    [ ./terminal/wezterm.nix ./shell.nix ./aliases.nix ./webman.nix ./emacs ];

  # nixpkgs = {
  #   overlays = [
  #     outputs.overlays.additions
  #     outputs.overlays.modifications
  #     outputs.overlays.weissNur
  #     outputs.overlays.lts
  #   ];
  #   config = {
  #     allowUnfree = true;
  #     # Workaround for https://github.com/nix-community/home-manager/issues/2942
  #     allowUnfreePredicate = (_: true);
  #   };
  # };

  programs = {
    home-manager.enable = true;
    git.enable = true;
    htop.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home = {
    keyboard.layout = "de";
    stateVersion = "22.11";
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
