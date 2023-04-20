{ pkgs, lib, myLib, myEnv, secrets, config, inputs, outputs, ... }:
with lib;
with myEnv; {
  imports = [ ./xmonad ./psql.nix ];

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
      displayManager.autoLogin.user = "weiss";
    };
  };

  programs = {
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "gnome3";
    };
  };

  environment = {
    sessionVariables = {
      LEDGER_FILE = "\${HOME}/finance/2021.journal";
      POSTGIS_DIESEL_DATABASE_URL = "postgres://weiss@localhost/digivine";
    };
  };

  sound.enable = false;
  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
  };
}
