{
  config,
  myEnv,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  # myXmonad = import ./myXmonad { pkgs = pkgs; };
  xmobarDir = "${myEnv.homeDir}" + "/.config/xmobar";
in
{
  environment = {
    systemPackages = with pkgs; [
      xorg.xdpyinfo
      xorg.xrandr
      arandr
      xmobar
      dmenu
      rofi
      # haskellPackages.status-notifier-item
    ];
  };

  services.xserver.windowManager.xmonadBin = {
    enable = true;
    binPath = "${pkgs.weissXmonad}/bin/weiss-xmonad-exe";
  };
}
