{ config, myEnv, myLib, lib, pkgs, ... }:
(myEnv.ifLinux {
  services.xscreensaver = {
    enable = false;
    settings = {
      fadeTicks = 20;
      timeout = "0:02:00";
      mode = "blank";
      selected = "-1";
      # programs = "pacman --root";
    };
  };
})

