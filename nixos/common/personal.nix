{ pkgs, lib, myLib, myEnv, secrets, config, inputs, outputs, configSession, ...
}:
with lib;
with myEnv; {
  imports = [ ./minimum.nix ./xmonad ./psql.nix ];

  services = {
    xserver = {
      enable = true;
      autorun = true;
      libinput.enable = true;
      layout = "de";
      autoRepeatDelay = 230;
      autoRepeatInterval = 30;
      # Enable automatic login for the user.
      displayManager.autoLogin.enable = true;
      displayManager.autoLogin.user = "${username}";
      libinput.touchpad = {
        naturalScrolling = true;
        accelSpeed = "0.5"; # float number between -1 and 1.
      };
    };
    blueman.enable = true;
    myPostgresql = {
      enable = true;
      package = pkgs.lts.postgresql_15;
    };
  };

  programs = {
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "gnome3";
    };
  };

  environment = {
    systemPackages = with pkgs; [ pavucontrol xdotool ];
    sessionVariables = {
      LEDGER_FILE = "\${HOME}/finance/2021.journal";
      POSTGIS_DIESEL_DATABASE_URL = "postgres://weiss@localhost/digivine";
    };
  };

  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };
}
