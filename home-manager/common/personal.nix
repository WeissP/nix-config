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
    ./shell.nix
    ./aliases.nix
    ./hledger.nix
    ./sioyek.nix
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
              # zenith
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
              dbeaver
              pdfminer
              (rWrapper.override { packages = with rPackages; [ purrr ]; })
              additions.ammonite.ammonite_3_2
              ghostscript
              (python3.withPackages (ps:
                with ps; [
                  pip
                  pygments # for latex minted
                  # (buildPythonPackage rec {
                  #   pname = "nougat";
                  #   version = "0.1.17";
                  #   src = fetchFromGitHub {
                  #     owner = "facebookresearch";
                  #     repo = pname;
                  #     rev = "47c77d70727558b4a2025005491ecb26ee97f523";
                  #     sha256 =
                  #       "sha256-Uc6DTJLPeVIUTDZRfaRPxblBY56uK8wcsfC41M4/Lz8=";
                  #   };
                  #   # src = fetchPypi {
                  #   #   inherit pname version;
                  #   #   sha256 =
                  #   #     "sha256-0aozmQ4Eb5zL4rtNHSFjEynfObUkYlid1PgMDVmRkws=";
                  #   # };
                  #   doCheck = false;
                  #   propagatedBuildInputs = with pkgs.python3Packages; [
                  #     transformers
                  #     timm
                  #     orjson
                  #     # opencv-python-headless
                  #     lightning
                  #     nltk
                  #     python-Levenshtein
                  #     sentencepiece
                  #     # sconf
                  #     albumentations
                  #     # pypdfium2
                  #     torch
                  #     tqdm
                  #     pypdf
                  #     cv2
                  #   ];
                  # })
                ]))
              (texlive.combine {
                inherit (texlive)
                  scheme-tetex collection-langkorean algorithms cm-super pgf
                  dvipng dvisvgm enumitem graphics wrapfig amsmath ulem hyperref
                  capt-of framed multirow vmargin comment minted doublestroke
                  pgfplots titlesec subfigure adjustbox algorithm2e ifoddpage
                  relsize qtree pict2e lipsum ifsym fontawesome changepage
                  inconsolata xcolor cancel stmaryrd wasysym wasy makecell
                  forest mnsymbol biblatex fontawesome5 pbox;
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
              mattermost-desktop
              simplescreenrecorder
              xbindkeys
              xautomation
              lsof
              # cider
              libnotify
              qq
              ocamlPackages.cpdf
              poppler_utils
              # openssl problem
              # wkhtmltopdf-bin 
              nodejs
              tlaplus
              tlaplusToolbox
              graphviz
              librsvg
              aria2
              pasystray
              vivaldi
              pdfpc
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

        programs = { gpg = { enable = true; }; };

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

