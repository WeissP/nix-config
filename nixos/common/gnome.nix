{
  config,
  myEnv,
  lib,
  pkgs,
  inputs,
  secrets,
  ...
}:
with myEnv;
{
  config = lib.mkMerge [
    {
      environment = {
        systemPackages = with pkgs; [
          gnomeExtensions.paperwm
          xorg.xdpyinfo
          xorg.xrandr
          arandr
          dmenu
          rofi
        ];
      };

      services = {
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
        # xserver = {

        # };
      };
    }
  ];
}
