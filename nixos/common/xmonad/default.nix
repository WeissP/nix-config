{ config, myEnv, lib, pkgs, ... }:

let
  myXmonad = import ./myXmonad { pkgs = pkgs; };
  xmobarDir = "${myEnv.homeDir}" + "/.config/xmobar";
in {
  environment = {
    variables = { SCRIPTS_DIR = myEnv.scriptsDir; };
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
        haskellPackages =
          pkgs.haskellPackages.extend (self: super: { xmonad = myXmonad; });
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
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = lib.mkForce false;
      displayManager = {
        defaultSession = "none+xmonad";
        sessionCommands = ''
          # emacs &
          chromium &
          xbindkeys &
          sh $HOME/.screenlayout/horizontal.sh &
          sh ${myEnv.scriptsDir}/mouse_scroll.sh &
        '';
      };
    };
  };
}
