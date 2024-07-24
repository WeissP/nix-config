{ pkgs, myEnv, myLib, lib, ... }:
myEnv.ifLinux {
  home.packages = [ pkgs.dconf ];
  services.darkman = rec {
    enable = true;
    settings = { usegeoclue = true; };
    darkModeScripts = {
      xsettings = ''
        ${pkgs.xfce.xfconf}/bin/xfconf-query --create --type string -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
      '';
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"  '';
    };
    lightModeScripts = {
      xsettings = ''
        ${pkgs.xfce.xfconf}/bin/xfconf-query --create --type string -c xsettings -p /Net/ThemeName -s "Adwaita"
      '';
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"  '';
    };
  };
}

