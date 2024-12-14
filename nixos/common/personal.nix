{
  pkgs,
  lib,
  myLib,
  myEnv,
  secrets,
  config,
  inputs,
  outputs,
  configSession,
  ...
}:
with lib;
with myEnv;
{
  imports = [
    ./minimum.nix
    ./xmonad
    ./psql.nix
    ./syncthing.nix
    ./zsh.nix
    ./uxplay.nix
    ./sunshine.nix
    ./fonts.nix
  ];

  networking = {
    networkmanager.enable = true;
  };
  services = {
    joycond.enable = true;
    geoclue2.enable = true;
    # Enable automatic login for the user.
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "${username}";
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        accelSpeed = "0.5"; # float number between -1 and 1.
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
    xserver = {
      enable = true;
      autorun = true;
      videoDrivers = [ "amdgpu" ];

      xkb = {
        layout = "de";
        variant = ",nodeadkeys";
      };
      wacom.enable = true;
      autoRepeatDelay = 230;
      autoRepeatInterval = 30;
      displayManager.sessionCommands = ''
        export PATH=$PATH:${scriptsDir}
        sh $HOME/.screenlayout/desktop.sh &
        sh mouse_scroll.sh &
        floorp &
        xbindkeys &
        pasystray &
        pueued &
        pueue add -i xsettingsd &
        Exec=GTK_IM_MODULE= QT_IM_MODULE= XMODIFIERS= emacs &
        sh mapwacom.sh --device-regex ".*Wacom.*" -s "DisplayPort-0" &
      '';
    };
    blueman.enable = true;
    myPostgresql = {
      enable = true;
      package = pkgs.lts.postgresql_15;
    };
  };

  programs = {
    zsh.enable = true;
    git = {
      enable = true;
    };
  };

  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      protontricks
      git-crypt
      ripgrep
      cachix
      fd
      killall
      locale
      unzip
      zip
      pavucontrol
      xdotool
      wezterm
      babashka
      udisks
      xdg-user-dirs
      # config.nur.repos.novel2430.wechat-universal-bwrap
      # config.nur.repos.pokon548.wechat-uos
    ];
  };

  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
    graphics.enable32Bit = true;
    pulseaudio.support32Bit = true;

  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

}
