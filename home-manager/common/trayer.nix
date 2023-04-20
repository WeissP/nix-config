{ pkgs, config, myEnv, ... }:
(myEnv.ifLinux {
  xsession.enable = true;
  services.trayer = {
    enable = true;
    settings = {
      monitor = 0;
      edge = "top";
      distancefrom = "top";
      SetDockType = false;
      SetPartialStrut = false;
      expand = true;
      widthtype = "request";
      # width = 20;
      align = "right";
      transparent = true;
      alpha = 0;
      tint = "0x2e3440";
      height = 24;
    };
  };
})

