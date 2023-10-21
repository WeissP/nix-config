{ pkgs, myEnv, lib, ... }:

(myEnv.ifLinux {
  services = {
    fusuma = rec {
      enable = true;
      extraPackages = with pkgs; [ xdotool coreutils ];
      settings = {
        swipe = {
          "3" = {
            left.command = "xdotool key control+Tab";
            right.command = "xdotool key control+shift+Tab";
            up.command = "xdotool key End";
            down.command = "xdotool key Home";
          };
          "4" = {
            left.command = "xdotool key alt+Right";
            right.command = "xdotool key alt+Left";
            up.command = "xdotool key control+w";
            down.command = "xdotool key control+shift+t";
          };
        };
        pinch = {
          "2" = {
            "in" = {
              command = "xdotool keydown ctrl click 5 keyup ctrl";
              threshold = 0.8;
              interval = 0.7;
            };
            "out" = {
              command = "xdotool keydown ctrl click 4 keyup ctrl";
              threshold = 0.8;
              interval = 0.7;
            };
          };
          "3" = {
            "in" = {
              command = "xdotool key control+v";
              threshold = 0.8;
              interval = 2;
            };
            "out" = {
              command = "xdotool key control+c";
              threshold = 0.8;
              interval = 1;
            };
          };
        };
      };
    };
  };
})
