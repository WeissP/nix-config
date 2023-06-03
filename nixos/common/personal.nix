{ pkgs, lib, myLib, myEnv, secrets, config, inputs, outputs, configSession, ...
}:
with lib;
with myEnv; {
  imports = [ ./minimum.nix ./xmonad ./psql.nix ./syncthing.nix ./zsh.nix ];

  services = {
    xserver = {
      enable = true;
      autorun = true;
      libinput.enable = true;
      layout = "de";
      xkbVariant = ",nodeadkeys";
      autoRepeatDelay = 230;
      autoRepeatInterval = 30;
      # Enable automatic login for the user.
      displayManager.autoLogin.enable = true;
      displayManager.autoLogin.user = "${username}";
      libinput.touchpad = {
        naturalScrolling = true;
        accelSpeed = "0.5"; # float number between -1 and 1.
      };
      displayManager.sessionCommands = ''
        Exec=GTK_IM_MODULE= QT_IM_MODULE= XMODIFIERS= emacs &
        cider &
        chromium &
        xbindkeys &
        sh $HOME/.screenlayout/horizontal.sh &
        sh ${myEnv.scriptsDir}/mouse_scroll.sh &
      '';
    };
    blueman.enable = true;
    myPostgresql = {
      enable = true;
      package = pkgs.lts.postgresql_15;
    };
  };

  programs = { zsh.enable = true; };

  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [ pavucontrol xdotool wezterm babashka udisks ];
  };

  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };
}
