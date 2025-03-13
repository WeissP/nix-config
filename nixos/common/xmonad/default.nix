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
lib.mkMerge [
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

    services.xserver = {
      windowManager.xmonadBin = {
        enable = true;
        binPath = "${pkgs.weissXmonad}/bin/weiss-xmonad-exe";
      };
    };
  }
  (lib.optionalAttrs (location == "home") {
    services.getty.autologinUser = "${username}";
  })
  (lib.optionalAttrs (location != "home") {
    services.xserver = {
      displayManager = {
        lightdm = {
          enable = true;
          greeters.slick.enable = true;
        };
      };
    };
  })
]
