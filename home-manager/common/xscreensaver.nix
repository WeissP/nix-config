{ config, myEnv, myLib, lib, pkgs, ... }:
(myEnv.ifLinux {
  services.xscreensaver = {
    enable = true;
    settings = {
      fadeTicks = 20;
      timeout = "0:45:00";
      mode = "blank";
      selected = "-1";

      # mode = "one";
      # selected = "0";
      # programs = "pacman --root";
    };
  };
})

