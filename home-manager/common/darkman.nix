{ pkgs, myEnv, myLib, lib, ... }:
myEnv.ifLinux {
  home.packages = [ pkgs.dconf ];
  services.darkman = rec {
    enable = true;
    settings = { usegeoclue = true; };
    darkModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"  '';
    };
    lightModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"  '';
    };
  };
}

