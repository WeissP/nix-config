{ inputs, outputs, myEnv, lib, config, pkgs, username, secrets, myLib, ... }: {
  imports = [
    ./minimum.nix
    ./terminal/wezterm.nix
    ./emacs
    ./email.nix
    ./pass.nix
    ./chromium.nix
    ./mpv.nix
    ./trayer.nix
    ./fusuma.nix
    ./flameshot.nix
    ./webman.nix
    ./shell
    ./hledger.nix
    ./sioyek.nix
    ./xscreensaver.nix
    # ./darkman.nix
  ] ++ (if myEnv.arch == "linux" then [ ./aria.nix ] else [ ]);

  config = with myEnv;
    lib.mkMerge [
      {
        home = let configDir = config.xdg.configHome;
        in lib.mkMerge [
          {
            sessionVariables = { SCRIPTS_DIR = myEnv.scriptsDir; };
            file = {
              "${homeDir}/scripts" = {
                source = ./config_files/scripts;
                recursive = true;
              };
              "${homeDir}/.ssh/id_rsa".text = secrets.ssh."163".private;
            };
            packages = with pkgs; [
              nodejs
              unrar
              zenith
              nil
              docker-compose
              dua
              xmlstarlet
              p7zip
              lux
              yt-dlp
              pandoc
              zoom-us
              ripgrep-all
              imagemagick
              # v2ray
              coreutils
              # calibre
              pdfminer
              (rWrapper.override {
                packages = with rPackages; [ purrr ggplot2 ];
              })
              # additions.ammonite.ammonite_3_2
              scala-cli
              jdk17
              ghostscript
              (python3.withPackages
                (ps: with ps; [ pip pygments numpy matplotlib ]))
              (texlive.combine {
                inherit (texlive)
                  scheme-tetex collection-langkorean algorithms cm-super pgf
                  dvipng dvisvgm enumitem graphics wrapfig amsmath ulem hyperref
                  capt-of framed multirow vmargin comment minted doublestroke
                  pgfplots titlesec subfigure adjustbox algorithm2e ifoddpage
                  relsize qtree pict2e lipsum ifsym fontawesome changepage
                  inconsolata xcolor cancel stmaryrd wasysym wasy makecell
                  forest mnsymbol biblatex fontawesome5 pbox rsfso upquote;
                pkgFilter = pkg:
                  pkg.tlType == "run" || pkg.tlType == "bin" || pkg.pname
                  == "cm-super";
                # elem tlType [ "run" "bin" "doc" "source" ]
                # there are also other attributes: version, name
              })
            ];
          }
          (ifDarwin { packages = with pkgs; [ iterm2 ocamlPackages.cpdf ]; })
          (ifLinux {
            packages = with pkgs; [
              apfs-fuse
              aria2
              cider
              graphviz
              libnotify
              libreoffice
              librsvg
              lsof
              mattermost-desktop
              nodejs
              ocamlPackages.cpdf
              p3x-onenote
              pasystray
              pdfpc
              poppler_utils
              qq
              simplescreenrecorder
              tlaplus
              dbeaver-bin
              tlaplusToolbox
              vivaldi
              wkhtmltopdf-bin
              wmctrl
              xautomation
              xbindkeys
              xorg.setxkbmap
              xournalpp
              # microsoft-edge
              # mathpix-snipping-tool
              # pinnedUnstables."2023-09-27".webkitgtk
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
              "${homeDir}/.config/sqlfluff/.sqlfluff" = {
                source = ./config_files/sqlfluff/sqlfluff.cfg;
                recursive = false;
              };
            };
          })
        ];
        programs = {
          direnv = {
            enable = true;
            nix-direnv.enable = true;
            enableZshIntegration = true;
          };
        };
      }
      (ifLinux {
        systemd.user = {
          services = with myLib.service; {
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
            nodeadkeys = {
              Unit.Description = "Set keyboard layout to nodeadkeys";
              Service = {
                ExecStart =
                  "${pkgs.xorg.setxkbmap}/bin/setxkbmap -layout de -variant nodeadkeys";
              };
            };
          };
          timers = {
            nodeadkeys = {
              Unit.Description = "Run nodeadkeys every 10 seconds";
              Timer = {
                OnBootSec = "5s";
                OnUnitActiveSec = "10sec";
                Unit = "nodeadkeys.service";
              };
              Install = { WantedBy = [ "timers.target" ]; };
            };
          };
        };

        i18n.inputMethod = {
          enabled = "fcitx5";
          fcitx5.addons = with pkgs; [
            fcitx5-rime
            fcitx5-configtool
            fcitx5-chinese-addons
          ];
        };

        programs = { gpg = { enable = true; }; };

        services = {
          pueue = { enable = false; };
          dunst.enable = true;
          blueman-applet.enable = true;
          mpris-proxy.enable = true; # let buttons of bluetooth devices work
          unclutter = {
            enable = true;
            extraOptions = [ "exclude-root" "ignore-scrolling" ];
          };
          gpg-agent = {
            enable = true;
            maxCacheTtl = 86400; # 24 hours
            pinentryPackage = pkgs.pinentry-gnome3;
          };
        };
      })
    ];
}

