{ inputs, outputs, lib, config, pkgs, secrets, ... }: {
  imports = [ ./common.nix ./xmonad ./psql.nix ];

  services.xserver = {
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

  environment = {
    sessionVariables = rec {
      LEDGER_FILE = "\${HOME}/finance/2021.journal";
      POSTGIS_DIESEL_DATABASE_URL = "postgres://weiss@localhost/digivine";
    };
    systemPackages = with pkgs; [ gnupg pass ];
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };
  services.dbus.packages = [ pkgs.gcr ];
  hardware.bluetooth.enable = true;
}
