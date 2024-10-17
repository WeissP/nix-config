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
  ];

  networking = {
    networkmanager.enable = true;
  };
  services = {
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
        firefox &
        xbindkeys &
        pasystray &
        pueued &
        pueue add -i xsettingsd &
        Exec=GTK_IM_MODULE= QT_IM_MODULE= XMODIFIERS= emacs &
        aria2c &
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
      git-crypt
      ripgrep
      cachix
      fd
      killall
      locale
      unzip
      zip
      v2ray
      pavucontrol
      xdotool
      wezterm
      babashka
      udisks
      config.nur.repos.xddxdd.wechat-uos-bin
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

  fonts = mkMerge [
    {
      fontDir.enable = true;
      packages =
        with pkgs;
        let
          mkFont = callPackage myLib.mkFont { };
        in
        [
          (mkFont "florencesans-sc" "florencesans-sc.zip")
          (mkFont "monolisa" "monolisa.zip")
          route159
          noto-fonts
          noto-fonts-cjk
          noto-fonts-emoji
          stix-two
          liberation_ttf
          fira-code
          fira-code-symbols
          (nerdfonts.override { fonts = [ "FiraCode" ]; })
          mplus-outline-fonts.githubRelease
          dina-font
          source-code-pro
          source-han-sans
          source-han-serif
          lato
          jetbrains-mono
          cascadia-code
          sarasa-gothic
          emacs-all-the-icons-fonts
          wqy_microhei
          wqy_zenhei
        ];
    }
    (ifLinux {
      fontconfig = {
        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          monospace = [
            "Noto Sans Mono CJK SC"
            "Sarasa Mono SC"
            "DejaVu Sans Mono"
          ];
          sansSerif = [
            "Noto Sans CJK SC"
            "Source Han Sans SC"
            "DejaVu Sans"
          ];
          serif = [
            "Noto Serif CJK SC"
            "Source Han Serif SC"
            "DejaVu Serif"
          ];
        };
      };
    })
  ];

}
