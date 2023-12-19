{ config, lib, pkgs, ... }: {
  services.xscreensaver = {
    enable = true;
    settings = {
      fadeTicks = 20;
      # timeout = "0:01:00";
      mode = "one";
      selected = 0;
      programs = "pacman --root";
    };
  };
}
