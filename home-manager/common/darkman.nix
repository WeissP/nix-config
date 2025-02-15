{
  pkgs,
  myEnv,
  myLib,
  secrets,
  ...
}:
let
  xsettingsDir = "${myEnv.homeDir}/.config/xsettingsd";
  xsettingsConf = "${xsettingsDir}/xsettingsd.conf";
  notifyBin = "${pkgs.libnotify}/bin/notify-send";
  killallBin = "${pkgs.killall}/bin/killall";
in
with myEnv;
ifLinux {
  home = {
    packages = with pkgs; [
      materia-theme
      xsettingsd
    ];
  };
  services = {
    xsettingsd.enable = true;
    darkman = {
      enable = true;
      settings = with secrets.locations."${location}"; {
        inherit lat lng;
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
  };
}
