{ inputs, outputs, lib, config, pkgs, username, secrets, myLib, ... }: {
  imports = [
    outputs.homeManagerModules.recentf
    # outputs.homeManagerModules.setup
    ./common.nix
    ./mpv.nix
    ./terminal/wezterm.nix
    ./shell.nix
    ./aliases.nix
    # ./emacs.nix
    ./chromium.nix
    ./email.nix
    ./trayer.nix
    ./recentf.nix
    ./emacs
    # ./syncthing.nix
  ];

  # services.setup = {
  #   enable = true;
  #   commands = [
  #     "pushd ~/"
  #     "! [[ -d .password-store.git ]] && git clone git@github.com:WeissP/.password-store.git "
  #     "popd"
  #   ];
  # };

  systemd.user.services = with myLib.service; {
    flameshot = startup { cmds = "${pkgs.flameshot}/bin/flameshot"; };
    mouse_scroll =
      startup { cmds = "${myLib.homeDir username}/scripts/mouse_scroll.sh"; };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-chinese-addons ];
  };

  services = {
    blueman-applet.enable = true;
    mpris-proxy.enable = true; # let buttons of bluetooth devices work
    unclutter = {
      enable = true;
      extraOptions = [ "exclude-root" "ignore-scrolling" ];
    };
    xscreensaver.enable = true;
  };

  home = let
    configDir = config.xdg.configHome;
    homeDir = myLib.homeDir username;
  in {
    packages = with pkgs; [ xbindkeys flameshot cider calibre ];
    file = {
      ".xbindkeysrc".text = ''
        "xte 'keydown Control_L' 'key Tab' 'keyup Control_L' "
        b:8

        "xte 'keydown Control_L' 'keydown Shift_L' 'key Tab' 'keyup Control_L' 'keyup Shift_L'"
        b:9

        "xte 'keydown Control_L' 'key w' 'keyup Control_L'"
        b:10

        "xte 'keydown Control_L' 'key c' 'keyup Control_L'"
        b:6

        "xte 'keydown Control_L' 'key v' 'keyup Control_L'"
        b:7
      '';
      "${homeDir}/.local/share/fcitx5/rime" = {
        source = ./config_files/flypy;
        recursive = true;
      };
      "${configDir}/fcitx5" = {
        source = ./config_files/fcitx5;
        recursive = true;
      };
      "${configDir}/xmobar" = {
        source = ./config_files/xmobar;
        recursive = true;
      };
      "${configDir}/wezterm" = {
        source = ./config_files/wezterm;
        recursive = true;
      };
      "${homeDir}/.background-image" = {
        source = ./config_files/wallpaper;
        recursive = true;
      };
      "${homeDir}/scripts" = {
        source = ./config_files/scripts;
        recursive = true;
      };
      "${homeDir}/.screenlayout" = {
        source = ./config_files/screenlayout;
        recursive = true;
      };
      "${homeDir}/.ssh/id_rsa".text = secrets.ssh."163".private;
    };
  };

}
