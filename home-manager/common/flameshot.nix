{ pkgs, myEnv, myLib, lib, ... }:

with myEnv; {
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        disabledTrayIcon = false;
        showHelp = false;
        savePath = "${homeDir}/Downloads";
        filenamePattern = "flameshot-capture";
      };
    };
  };
}
