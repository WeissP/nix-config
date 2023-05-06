{ inputs, outputs, myEnv, lib, config, pkgs, username, secrets, myLib, ... }: {
  imports = [
    ./minimum.nix
    ./email.nix
    ./pass.nix
    ./chromium.nix
    ./mpv.nix
    ./trayer.nix
    ./fusuma.nix
    ./flameshot.nix
  ];

  config = with myEnv;
    lib.mkMerge [
      {
        home = let configDir = config.xdg.configHome;
        in lib.mkMerge [
          {
            sessionVariables = {
              SCRIPTS_DIR = myEnv.scriptsDir;
              # LEDGER_FILE = "\${HOME}/finance/2021.journal";
            };
            file = {
              "${homeDir}/scripts" = {
                source = ./config_files/scripts;
                recursive = true;
              };
              "${homeDir}/.ssh/id_rsa".text = secrets.ssh."163".private;
            };
            packages = with pkgs; [
              nodejs
              zenith
              elixir
              elixir-ls
              erlang
              nil
              docker-compose
              dua
              xmlstarlet
              (texlive.combine {
                inherit (texlive)
                  scheme-small collection-langkorean algorithms cm-super pgf
                  dvipng dvisvgm enumitem graphics wrapfig amsmath ulem hyperref
                  capt-of framed multirow vmargin comment minted;
                pkgFilter = pkg:
                  pkg.tlType == "run" || pkg.tlType == "bin" || pkg.pname
                  == "cm-super";
                # elem tlType [ "run" "bin" "doc" "source" ]
                # there are also other attributes: version, name
              })
            ];
          }
          (ifLinux {
            packages = with pkgs; [
              mattermost-desktop
              simplescreenrecorder
              xbindkeys
              xautomation
              cider
              calibre
              dolphin
              libnotify
            ];
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
              # "${homeDir}/.local/share/fcitx5/rime" = {
              #   source = ./config_files/flypy;
              #   recursive = true;
              # };
              # "${configDir}/fcitx5" = {
              #   source = ./config_files/fcitx5;
              #   recursive = true;
              # };
              "${configDir}/xmobar" = {
                source = ./config_files/xmobar;
                recursive = true;
              };
              "${homeDir}/.background-image" = {
                source = ./config_files/wallpaper;
                recursive = true;
              };
              "${homeDir}/.screenlayout" = {
                source = ./config_files/screenlayout;
                recursive = true;
              };
            };
          })
        ];
        programs = {
          direnv = {
            enable = true;
            nix-direnv.enable = true;
          };
        };
      }
      (ifLinux {
        systemd.user.services = with myLib.service; {
          # cider = startup { cmds = "${pkgs.cider}/bin/cider"; };
          init_dir = startup {
            cmds = ''
              pushd ~/
              ! [[ -d .password-store.git ]] && git clone git@github.com:WeissP/.password-store.git 
              popd
            '';
          };
          # mouse_scroll =
          #   startup { cmds = "${homeDir}/scripts/mouse_scroll.sh"; };
        };

        i18n.inputMethod = {
          enabled = "fcitx5";
          fcitx5.addons = with pkgs; [
            fcitx5-rime
            fcitx5-configtool
            fcitx5-chinese-addons
          ];
        };

        services = {
          dunst.enable = true;
          blueman-applet.enable = true;
          mpris-proxy.enable = true; # let buttons of bluetooth devices work
          unclutter = {
            enable = true;
            extraOptions = [ "exclude-root" "ignore-scrolling" ];
          };
          xscreensaver.enable = true;
          gpg-agent = {
            enable = true;
            maxCacheTtl = 86400; # 24 hours
            pinentryFlavor = "gnome3";
          };
        };
      })
    ];
}

