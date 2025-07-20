{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.niri = {
    package = pkgs.niri-stable;
    settings = {
      environment = {
        CLUTTER_BACKEND = "wayland";
        DISPLAY = null;
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland";
      };
      binds = with config.lib.niri.actions; {
        # "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
        # "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";

        "Mod+D".action = spawn "fuzzel";
        "Mod+1".action = focus-workspace 1;

        # "Mod+Shift+E".action = quit;
        # "Mod+Ctrl+Shift+E".action = quit { skip-confirmation = true; };

        # "Mod+Plus".action = set-column-width "+10%";
      };
    };
  };
}
