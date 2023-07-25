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
        mattermost-desktop &
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

  fonts = mkMerge [
    {
      fontDir.enable = true;
      fonts = with pkgs; [
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
          monospace =
            [ "Noto Sans Mono CJK SC" "Sarasa Mono SC" "DejaVu Sans Mono" ];
          sansSerif = [ "Noto Sans CJK SC" "Source Han Sans SC" "DejaVu Sans" ];
          serif = [ "Noto Serif CJK SC" "Source Han Serif SC" "DejaVu Serif" ];
        };
      };
    })
  ];

}
