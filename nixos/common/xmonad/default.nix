{ config, myEnv, lib, pkgs, ... }:

let
  myXmonad = import ./myXmonad { pkgs = pkgs; };
  xmobarDir = "${myEnv.homeDir}" + "/.config/xmobar";
in {
  environment.systemPackages = with pkgs; [
    xorg.xdpyinfo
    xorg.xrandr
    arandr
    # autorandr
    # xterm
    xmobar
    dmenu
    picom
    rofi
  ];

  services = {
    dbus.enable = true;
    xserver = {
      enable = true;
      autorun = true;

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = false;
        haskellPackages =
          pkgs.haskellPackages.extend (self: super: { xmonad = myXmonad; });
        # extraPackages = (haskellPackages: [ haskellPackages.taffybar ]);
        config = ''
          module Main where

          import MyXMonad 
          import MyLogger
          import MyNamedScratchpad
          import MyPromptPass
          import MyWindowOperations
          import MyXmobar

          main :: IO ()
          main = MyXMonad.runXmonad "${xmobarDir}"
        '';
      };
      displayManager.sddm.enable = lib.mkForce false;
      desktopManager.plasma5.enable = lib.mkForce false;
      displayManager = {
        defaultSession = "none+xmonad";
        lightdm.enable = true;
        sessionCommands = ''
          wezterm&
        '';
      };
    };
  };
}
