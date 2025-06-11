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
  imports = [ ./picom.nix ];
  config = lib.mkMerge [
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

      services = {
        xserver = {
          windowManager.xmonadBin = {
            enable = true;
            binPath = "${pkgs.weissXmonad}/bin/weiss-xmonad-exe";
          };
        };

        autorandr = {
          hooks.postswitch = {
            restartXmonad = "${pkgs.weissXmonad}/bin/weiss-xmonad-exe --restart";
          };
        };
      };
    }
    (lib.optionalAttrs (location == "home") {
      # Enable automatic login for the user.
      services.displayManager.autoLogin = {
        enable = true;
        user = "${username}";
      };
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
  ];
}
