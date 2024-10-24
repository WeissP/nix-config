{
  pkgs,
  myEnv,
  myLib,
  lib,
  secrets,
  configSession,
  ...
}:
with myEnv;
let
  connector = "DisplayPort-1";
  autoresScript = pkgs.writeScript "autores-script" ''
    #!/usr/bin/env bash

    # Get params and set any defaults
    width=''${SUNSHINE_CLIENT_WIDTH}
    height=''${SUNSHINE_CLIENT_HEIGHT}

    # You may need to adjust the scaling differently so the UI/text isn't too small / big
    scale=1

    # Get the name of the active display
    display_output="${connector}"

    # Get the modeline info from the 2nd row in the cvt output
    modeline=$(cvt ''${width} ''${height} ''${refresh_rate} | awk 'FNR == 2')
    xrandr_mode_str=''${modeline//Modeline \"*\" /}
    mode_alias="''${width}x''${height}"

    xrandr --newmode ''${mode_alias} ''${xrandr_mode_str}
    xrandr --addmode ''${display_output} ''${mode_alias}

    # Reset scaling
    xrandr --output ''${display_output} --scale 1

    # Apply new xrandr mode
    xrandr --output ''${display_output} --primary --mode ''${mode_alias} --pos 0x0 --rotate normal --scale ''${scale}  --output DisplayPort-0 --off

    # Optional reset your wallpaper to fit to new resolution
    # xwallpaper --zoom /path/to/wallpaper.png
  '';
in
{
  services.sunshine = {
    enable = true;
    openFirewall = true;
    settings = {
      port = 39999;
    };
    applications = {
      env = with pkgs; {
        PATH = lib.makeBinPath [
          coreutils
          xorg.xrandr
          bash
          gnugrep
          gawkInteractive
          xorg.libxcvt
          steam
          util-linux
        ];
      };
      apps = [
        {
          name = "Disco Elysium";
          prep-cmd = [
            {
              do = autoresScript;
              undo = ''
                bash /home/weiss/.screenlayout/desktop.sh
                systemctl --user restart trayer
              '';
            }
          ];
          exclude-global-prep-cmd = "false";
          detached = [
            "setsid steam steam://rungameid/632470"
          ];
          output = "/tmp/DiscoElysium.log";
          auto-detach = "true";
        }
      ];
    };
  };
}
