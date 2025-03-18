{

  inputs,
  outputs,
  myEnv,
  lib,
  config,
  pkgs,
  secrets,
  myLib,
  ...
}:
{
  imports =
    [
      ./minimum.nix
      ./terminal/wezterm.nix
      ./emacs
      ./email.nix
      ./pass.nix
      ./webman.nix
      ./shell
      ./ripgrep.nix
      ./browser.nix
      ./aider.nix
      ./singboxConfig.nix
      ./mpv.nix
    ]
    ++ (
      if myEnv.arch == "linux" then
        [
          ./trayer.nix
          ./fusuma.nix
          ./flameshot.nix
          ./xscreensaver.nix
          ./darkman.nix
          ./ariang.nix
          ./sioyek.nix
          ./autorandr.nix
        ]
      else
        [ ]
    )
    ++ (
      if location == "home" then
        [
          ./hledger.nix
          ./chromium.nix
        ]
      else
        [ ]
    );

  config =
    with myEnv;
    lib.mkMerge [
      {
        home =
          let
            configDir = config.xdg.configHome;
          in
          lib.mkMerge [
            {
              sessionPath = [
                scriptsDir
              ];
              sessionVariables = {
                SCRIPTS_DIR = myEnv.scriptsDir;
                RASP_IP = secrets.nodes.RaspberryPi.localIp;
                DESKTOP_IP = secrets.nodes.desktop.localIp;
              };
              file = {
                "${homeDir}/scripts" = {
                  source = ./config_files/scripts;
                  recursive = true;
                };
                "${homeDir}/.ssh/id_rsa".text = secrets.ssh."163".private;
              };
              packages = with pkgs; [
                fd
                bibtex-tidy
                wget
                alacritty
                unrar
                p7zip
                yt-dlp
                pueue
                zoom-us
                imagemagick
                gnumake
                cmake
                niv
                # calibre
                pdfminer
                anki-bin
                (rWrapper.override {
                  packages = with rPackages; [
                    purrr
                    ggplot2
                  ];
                })
                # additions.ammonite.ammonite_3_2
                ghostscript
              ];
            }
            (ifDarwin {
              packages = with pkgs; [
                iterm2
                ocamlPackages.cpdf
                (texlive.combine {
                  inherit (texlive)
                    scheme-tetex
                    collection-langkorean
                    algorithms
                    cm-super
                    pgf
                    dvipng
                    dvisvgm
                    enumitem
                    graphics
                    wrapfig
                    amsmath
                    ulem
                    hyperref
                    capt-of
                    framed
                    multirow
                    vmargin
                    comment
                    minted
                    doublestroke
                    pgfplots
                    titlesec
                    subfigure
                    adjustbox
                    algorithm2e
                    ifoddpage
                    relsize
                    qtree
                    pict2e
                    lipsum
                    ifsym
                    fontawesome
                    changepage
                    inconsolata
                    xcolor
                    cancel
                    stmaryrd
                    wasysym
                    wasy
                    makecell
                    forest
                    mnsymbol
                    biblatex
                    fontawesome5
                    pbox
                    rsfso
                    upquote
                    acmart
                    ieeetran
                    beamertheme-arguelles
                    alegreya
                    fontaxes
                    mathalpha
                    opencolor
                    tcolorbox
                    ;
                  pkgFilter = pkg: pkg.tlType == "run" || pkg.tlType == "bin" || pkg.pname == "cm-super";
                  # builtins.elem tlType [ "run" "bin" "doc" "source" ]
                  # there are also other attributes: version, name
                })
              ];
            })
            (ifLinux {
              pointerCursor = {
                package = pkgs.afterglow-cursors-recolored;
                name = "Afterglow-Recolored-Gruvbox-Blue";
                size = 32;
                x11.enable = true;
                gtk.enable = true;
              };
              packages = with pkgs; [
                (texlive.combine {
                  inherit (texlive) scheme-full;
                  pkgFilter = pkg: pkg.tlType == "run" || pkg.tlType == "bin" || pkg.pname == "cm-super";
                })
                bluetui
                pdf4qt
                ffmpeg
                # nur.repos.xddxdd.wechat-uos-bin
                qemu
                nix-alien
                vdhcoapp
                taplo
                sqlite
                zotero
                steam
                jellyfin-media-player
                lts.calibre
                jellyfin-mpv-shim
                qrencode
                ripgrep-all
                black
                (python3.withPackages (
                  ps: with ps; [
                    python-lsp-server
                    matplotlib
                    pygments
                    seaborn
                  ]
                ))
                tree
                xfce.xfconf
                ssh-copy-id
                zenith
                nil
                nixd
                docker-compose
                dua
                scala-cli
                jdk17
                coreutils
                pandoc
                lux
                xmlstarlet
                lm_sensors
                nodejs
                feh
                amdgpu_top
                lshw
                jdk17
                jetbrains.idea-community-bin
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
                pdfpc
                poppler_utils
                qq
                simplescreenrecorder
                tlaplus
                dbeaver-bin
                tlaplusToolbox
                wkhtmltopdf-bin
                wmctrl
                xautomation
                xorg.setxkbmap
                xournalpp
                # microsoft-edge
                # mathpix-snipping-tool
                # pinnedUnstables."2023-09-27".webkitgtk
              ];
              file = {
                "${configDir}/xmobar" = {
                  source = ./config_files/xmobar;
                  recursive = true;
                };
                # "${homeDir}/.background-image" = {
                #   source = ./config_files/wallpaper;
                #   recursive = true;
                # };
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
        xdg.mimeApps = {
          enable = true;
          defaultApplications = {
            "application/pdf" = [ "sioyek.desktop" ];
            "image/png" = [ "feh" ];
          };
        };
        systemd.user = {
          services = {
            # start_steam = myLib.service.startup {
            #   inherit (myEnv) username;
            #   binName = "steam";
            # };
            mapwacom = with secrets.locations."${location}"; {
              Unit.Description = "map main screen to wacom";
              Install.WantedBy = [ "autostart.target" ];
              Service = {
                Type = "oneshot";
                RemainAfterExit = true;
                ExecStart = ''${scriptsDir}/mapwacom.sh --device-regex ".*Wacom.*" -s "${mainScreen}"'';
                PassEnvironment = "PATH";
              };
            };
            nodeadkeys = {
              Unit.Description = "Set keyboard layout to nodeadkeys";
              Service = {
                ExecStart = "${pkgs.xorg.setxkbmap}/bin/setxkbmap -layout de -variant nodeadkeys";
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
              Install = {
                WantedBy = [ "timers.target" ];
              };
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

        programs = {
          gpg = {
            enable = true;
          };
        };

        services = {
          pueue.enable = true;
          pasystray.enable = true;
          kdeconnect.enable = true;
          dunst.enable = true;
          blueman-applet.enable = false;
          mpris-proxy.enable = true; # let buttons of bluetooth devices work
          unclutter = {
            enable = true;
            extraOptions = [
              "exclude-root"
              "ignore-scrolling"
            ];
          };

          gpg-agent = {
            enable = true;
            maxCacheTtl = 86400; # 24 hours
            pinentryPackage = pkgs.pinentry-qt;
          };
        };
      })
    ];
}
