{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.services.xserver.windowManager.xmonadBin;
in
{
  options = {
    services.xserver.windowManager.xmonadBin = {
      enable = mkEnableOption "xmonadBin";
      binPath = mkOption {
        description = "absolute path to xmonad binary";
        type = types.str;
      };
    };
  };

  config =
    let
      xmonad =
        pkgs.runCommandLocal "xmonad"
          {
            nativeBuildInputs = [ pkgs.makeWrapper ];
          }
          (
            ''
              makeWrapper ${cfg.binPath} $out/bin/xmonad \
            ''
            + ''
              --set XMONAD_XMESSAGE "${pkgs.xorg.xmessage}/bin/xmessage"
            ''
          );
    in
    mkIf cfg.enable {
      services = {
        picom.enable = true;
        dbus.enable = true;
        displayManager = {
          sddm.enable = false;
          defaultSession = "none+xmonad";
        };
        xserver = {
          enable = true;
          autorun = true;

          windowManager.session = [
            {
              name = "xmonad";
              start = ''
                systemd-cat -t xmonad -- ${xmonad}/bin/xmonad &
                waitPID=$!
              '';
            }
          ];

        };
      };

      environment.systemPackages = [ xmonad ];
    };
}
