{

  inputs,
  outputs,
  myEnv,
  location,
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
      ./gtrash.nix
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
      ./notification.nix
      ./sioyek.nix
    ]
    ++ (
      if myEnv.arch == "linux" then
        [
          ./fusuma.nix
          ./flameshot.nix
          ./darkman.nix
          ./jellyfin-mpv-shim.nix
          ./autorandr.nix
        ]
      else
        [ ]
    )
    ++ (
      if myEnv.location == "uni" then
        [
          ./ytdl-sub.nix
        ]
      else
        [ ]
    )
    ++ (
      if (builtins.elem "daily" myEnv.usage) then
        [
          ./hledger.nix
          ./chromium.nix
          ./ariang.nix
          ./wired.nix
          ./prompts.nix
        ]
      else
        [ ]
    )
    ++ (
      if (myEnv.display == "wayland") then
        [
          ./fuzzel.nix
          ./niri.nix
        ]
      else if (myEnv.display == "Xorg") then
        [
          ./trayer.nix
          ./xscreensaver.nix
        ]
      else
        lib.asserts.assertMsg (myEnv.display == "none") "Unknow display" [ ]
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
              file = {
                "${homeDir}/.ssh/id_rsa".text = secrets.ssh."163".private;
              };
              packages = with pkgs; [
                bat
                fd
                exfat
                git-crypt
                bibtex-tidy
                prettier
                wget
                alacritty
                unrar
                p7zip
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
                # (texlive.combine {
                #   inherit (texlive)
                #     scheme-tetex
                #     collection-langkorean
                #     algorithms
                #     cm-super
                #     pgf
                #     dvipng
                #     dvisvgm
                #     enumitem
                #     graphics
                #     wrapfig
                #     amsmath
                #     ulem
                #     hyperref
                #     capt-of
                #     framed
                #     multirow
                #     vmargin
                #     comment
                #     minted
                #     doublestroke
                #     pgfplots
                #     titlesec
                #     subfigure
                #     adjustbox
                #     algorithm2e
                #     ifoddpage
                #     relsize
                #     qtree
                #     pict2e
                #     lipsum
                #     ifsym
                #     fontawesome
                #     changepage
                #     inconsolata
                #     xcolor
                #     cancel
                #     stmaryrd
                #     wasysym
                #     wasy
                #     makecell
                #     forest
                #     mnsymbol
                #     biblatex
                #     fontawesome5
                #     pbox
                #     rsfso
                #     upquote
                #     acmart
                #     ieeetran
                #     beamertheme-arguelles
                #     beamertheme-metropolis
                #     alegreya
                #     fontaxes
                #     mathalpha
                #     opencolor
                #     tcolorbox
                #     ;
                #   pkgFilter = pkg: pkg.tlType == "run" || pkg.tlType == "bin" || pkg.pname == "cm-super";
                # })
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
                (lts.texlive.combine {
                  inherit (texlive) scheme-full;
                  pkgFilter = pkg: pkg.tlType == "run" || pkg.tlType == "bin" || pkg.pname == "cm-super";
                })
                yutto
                devenv
                bluetui
                ffmpeg
                # nur.repos.xddxdd.wechat-uos-bin
                qemu
                google-java-format
                nix-alien
                taplo
                sqlite
                zotero
                calibre
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
                # jdk
                coreutils
                pandoc
                xmlstarlet
                lm_sensors
                nodejs
                feh
                lshw
                apfs-fuse
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
                "${configDir}/fcitx5" = {
                  source = ./config_files/fcitx5/dotconfig;
                  recursive = true;
                };
                "${homeDir}/.local/share/fcitx5" = {
                  source = ./config_files/fcitx5/share;
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
            (ifDisplay {
              packages = with pkgs; [
                syncthingtray
              ];
            })
            (ifUsage "daily" {
              sessionPath = [
                "/home/${username}/Documents/technical_assistant/dbis-exerciser/result/bin"
              ];
              packages = with pkgs; [
                lts.jetbrains.idea-community-bin
                inkscape
                llm
                mkvtoolnix
                steam
                jellyfin-media-player
                ausweisapp
                masterpdfeditor
                kdePackages.okular
                pdf4qt
                vdhcoapp
              ];
            })
          ];
        programs = {
          ssh = {
            enable = true;
            matchBlocks = {
              "home-server" = {
                hostname = secrets.nodes.homeServer.localIp;
                user = username;
              };
              "vultr" = {
                hostname = secrets.nodes.Vultr.publicIp;
                user = username;
              };
            };
          };
        };
      }
      (ifLinux {
        stylix.targets = {
          fcitx5.enable = false;
          emacs.enable = false;
          gtk.enable = false;
          # console.enable = false;
          # floorp.enable = false;
        };
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
            mapwacom = {
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
          enable = true;
          type = "fcitx5";
          fcitx5 =
            let
              p = pkgs.pinnedUnstables."2025-04-20";
            in
            {
              fcitx5-with-addons = p.kdePackages.fcitx5-with-addons;
              addons = with p; [
                fcitx5-rime
                fcitx5-gtk
                fcitx5-configtool
                fcitx5-chinese-addons
              ];
            };
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
            pinentry.package = pkgs.pinentry-qt;
          };
        };
      })
    ];
}
