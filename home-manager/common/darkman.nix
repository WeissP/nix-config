{ pkgs, myEnv, myLib, lib, ... }:
let
  xsettingsDir = "${myEnv.homeDir}/.config/xsettingsd";
  xsettingsConf = "${xsettingsDir}/xsettingsd.conf";
  xsettingsdBin = "${pkgs.xsettingsd}/bin/xsettingsd";
  notifyBin = "${pkgs.libnotify}/bin/notify-send";
  killallBin = "${pkgs.killall}/bin/killall";
in myEnv.ifLinux {
  home = { packages = with pkgs; [ materia-theme xsettingsd ]; };
  services.darkman = {
    enable = true;
    settings = {
      lat = 49.2;
      lng = 7.4;
    };
    darkModeScripts = {
      notification = ''
        ${notifyBin} --app-name="darkman" --urgency=low --icon=weather-clear-night "switching to dark mode"
      '';
      xsettings = ''
        mkdir -p ${xsettingsDir}
        echo 'Net/ThemeName "Materia-dark"' > ${xsettingsConf}
        sleep 0.1s
        ${killallBin} -HUP xsettingsd
      '';
    };
    lightModeScripts = {
      notification = ''
        ${notifyBin} --app-name="darkman" --urgency=low --icon=weather-clear "switching to light mode"
      '';
      xsettings = ''
        mkdir -p ${xsettingsDir}
        echo 'Net/ThemeName "Materia"' > ${xsettingsConf}
        sleep 0.1s
        ${killallBin} -HUP xsettingsd
      '';
    };
  };
}

