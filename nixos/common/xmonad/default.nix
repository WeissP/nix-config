{ config, myEnv, lib, pkgs, inputs, ... }:

let
  # myXmonad = import ./myXmonad { pkgs = pkgs; };
  xmobarDir = "${myEnv.homeDir}" + "/.config/xmobar";
in {
  environment = {
    systemPackages = with pkgs; [
      xorg.xdpyinfo
      xorg.xrandr
      arandr
      xmobar
      dmenu
      picom
      rofi
      # haskellPackages.status-notifier-item
    ];
  };

  services = {
    dbus.enable = true;
    displayManager = {
      sddm.enable = false;
      defaultSession = "none+xmonad";
    };
    xserver = {
      enable = true;
      autorun = true;

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = false;
        haskellPackages = pkgs.haskell.packages.ghc948.extend
          (self: super: { xmonad = pkgs.weissXmonad; });
        config = ''
          module Main where

          import WeissXMonad

          main :: IO ()
          main = WeissXMonad.runXmonad "${xmobarDir}"
        '';
      };
    };
  };
}
