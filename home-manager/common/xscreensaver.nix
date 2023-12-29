{ config, myEnv, myLib, lib, pkgs, ... }:
(myEnv.ifLinux {
  services.xscreensaver = {
    enable = false;
    settings = {
      fadeTicks = 20;
      timeout = "0:15:00";
      mode = "one";
      selected = "0";
      programs = "pacman --root";
    };
  };
})

