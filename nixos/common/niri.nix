{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdgOpenUsePortal = true;
    };
  };

  services.displayManager = {
    defaultSession = "niri";
    gdm = {
      enable = true;
    };
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
  };

  # <https://github.com/NixOS/nixpkgs/issues/19629>
  services.xserver.exportConfiguration = true;

  programs = {
    xwayland.enable = true;
  };
  environment.systemPackages = [ pkgs.alacritty ];
}
