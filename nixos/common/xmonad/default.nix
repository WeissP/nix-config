{ config, myEnv, lib, pkgs, inputs, ... }:

let
  myXmonad = import ./myXmonad { pkgs = pkgs; };
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
    ];
  };

  services = {
    dbus.enable = true;
    xserver = {
      enable = true;
      autorun = true;

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = false;
        haskellPackages = pkgs.haskellPackages.extend
          (self: super: { xmonad = pkgs.weissXmonad; });
        config = ''
          module Main where

          import WeissXMonad
          import WeissLogger
          import WeissNamedScratchpad
          import WeissPromptPass
          import WeissWindowOperations
          import WeissWorkspaces
          import WeissXmobar

          main :: IO ()
          main = WeissXMonad.runXmonad "${xmobarDir}"
        '';
      };
      displayManager.sddm.enable = false;
      desktopManager.plasma5.enable = lib.mkForce false;
      displayManager = { defaultSession = "none+xmonad"; };
    };
  };
}
