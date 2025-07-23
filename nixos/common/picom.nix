{
  pkgs,
  lib,
  config,
  ...
}:
{
  services =
    let
      mkParensList = values: {
        inherit values;
        kind = "parensList";
      };
    in
    {
      picom = {
        enable = true;
        settings = {
          use-ewmh-active-win = true;
        };
        rules = [
          {
            match = "window_type = 'tooltip'";
            opacity = 0.8;
            full-shadow = false;
            blur-background = false;
          }
          {
            match = "window_type = 'dock'";
            shadow = false;
          }
          {
            match = "window_type = 'dnd'";
            shadow = false;
            blur-background = false;
          }
          {
            match = "window_type = 'popup_menu'";
            opacity = 0.9;
          }
          {
            match = "window_type = 'dropdown_menu'";
            opacity = 0.9;
          }
          { 
            match = "class_g = 'Xmonad-easymotion'";
            opacity = 0.7;
            animations = mkParensList [
              {
                triggers = [
                  "open"
                  "show"
                ];
                preset = "slide-in";
                direction = "up";
                duration = 0.05;
              }
            ];
          }
          {
            match = "class_g = 'xmonad'";
            animations = mkParensList [
              {
                triggers = [
                  "open"
                  "show"
                ];
                preset = "appear";
                duration = 0.05;
              }
            ];
          }
          {
            match = "name ^= '[Scratchpad]'";
            opacity = 0.96;
            animations = mkParensList [
              {
                triggers = [
                  "open"
                  "show"
                ];
                preset = "appear";
                duration = 0.2;
                scale = 0.5;
              }
              {
                triggers = [
                  "close"
                  "hide"
                ];
                preset = "disappear";
                scale = 0.5;
                duration = 0.1;
              }
            ];
          }
          {
            match = "name ^= '[Scratchpad]' && focused = false";
            opacity = 0.8;
          }
          {
            match = "class_g = 'wired'";
            opacity = 0.8;
          }
        ];
        animations = [
          {
            triggers = [
              "close"
              "hide"
            ];
            preset = "disappear";
            duration = 0.1;
          }
          {
            triggers = [
              "open"
              "show"
            ];
            opacity = {
              curve = "cubic-bezier(0,1,1,1)";
              duration = 0.1;
              start = 0;
              end = "window-raw-opacity";
            };
            blur-opacity = "opacity";
            shadow-opacity = "opacity";
            offset-x = "(1 - scale-x) / 2 * window-width";
            offset-y = "(1 - scale-y) / 2 * window-height";
            scale-x = {
              curve = "cubic-bezier(0,1.2,1,1)";
              duration = 0.3;
              start = 0.6;
              end = 1;
            };
            scale-y = "scale-x";
            shadow-scale-x = "scale-x";
            shadow-scale-y = "scale-y";
            shadow-offset-x = "offset-x";
            shadow-offset-y = "offset-y";
          }
          {
            triggers = [ "geometry" ];
            scale-x = {
              curve = "cubic-bezier(0,0,0,1.28)";
              duration = 0.2;
              start = "(window-width-before / window-width) / 3";
              end = 1;
            };
            scale-y = {
              curve = "cubic-bezier(0,0,0,1.28)";
              duration = 0.2;
              start = "(window-height-before / window-height) / 3";
              end = 1;
            };
            offset-x = {
              curve = "cubic-bezier(0,0,0,1.28)";
              duration = 0.2;
              start = "(window-x-before - window-x) / 2";
              end = 0;
            };
            offset-y = {
              curve = "cubic-bezier(0,0,0,1.28)";
              duration = 0.2;
              start = "(window-y-before - window-y) / 2";
              end = 0;
            };

            shadow-scale-x = "scale-x";
            shadow-scale-y = "scale-y";
            shadow-offset-x = "offset-x";
            shadow-offset-y = "offset-y";
          }
        ];
      };
    };
}
