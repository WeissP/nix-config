{
  config,
  lib,
  pkgs,
  remoteFiles,
  myEnv,
  ...
}:
{
  home.packages = with pkgs; [ sshfs ];
  programs = { 
    yazi = {
      enable = true;
      shellWrapperName = "y";
      enableNushellIntegration = true;
      initLua = ''require("sshfs"):setup()'';
      settings = {
        mgr = {
          sort_by = "mtime";
          sort_reverse = true;
          sort_dir_first = false;
        };
        opener.extract = [
          {
            run = ''ouch d -y "$@"'';
            desc = "Extract here with ouch";
            for = "unix";
          }
        ];
        plugin = {
          prepend_previewers = [
            # Archive previewer
            {
              mime = "application/*zip";
              run = "ouch";
            }
            {
              mime = "application/x-tar";
              run = "ouch";
            }
            {
              mime = "application/x-bzip2";
              run = "ouch";
            }
            {
              mime = "application/x-7z-compressed";
              run = "ouch";
            }
            {
              mime = "application/x-rar";
              run = "ouch";
            }
            {
              mime = "application/vnd.rar";
              run = "ouch";
            }
            {
              mime = "application/x-xz";
              run = "ouch";
            }
            {
              mime = "application/xz";
              run = "ouch";
            }
            {
              mime = "application/x-zstd";
              run = "ouch";
            }
            {
              mime = "application/zstd";
              run = "ouch";
            }
            {
              mime = "application/java-archive";
              run = "ouch";
            }
          ];
        };
      };
      plugins = with pkgs; {
        mount = yaziPlugins.mount;
        ouch = yaziPlugins.ouch;
        sshfs = remoteFiles.sshfsYazi;
      };
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "<F5>";
            run = "refresh";
          }
          {
            on = "i";
            run = "leave";
          }
          {
            on = "T";
            run = "tab_create --current";
          }
          {
            on = "t";
            run = "toggle_all";
          }
          {
            on = "z";
            run = "plugin zoxide";
          }
          {
            on = "Z";
            run = "plugin fzf";
          }
          {
            on = "Q";
            run = "quit";
          }
          {
            on = "q";
            run = "quit --no-cwd-file";
          }
          {
            on = "x";
            run = "yank --cut";
          }
          {
            on = [
              "g"
              "j"
            ];
            run = "plugin zoxide";
            desc = "Cd with zoxide";
          }
          {
            on = "C";
            run = "plugin ouch";
            desc = "Compress with ouch";
          }
          # {
          #   on = [
          #     "M"
          #   ];
          #   run = "plugin sshfs -- mount --jump";
          #   desc = "sshfs Mount & jump";
          # }
          # {
          #   on = [
          #     "g"
          #     "s"
          #     "m"
          #   ];
          #   run = "cd ";
          #   desc = "sshfs jump";
          # }
          {
            on = "u";
            run = "plugin mount";
          }
          {
            on = [
              "g"
              "s"
              "m"
            ];
            run = "cd /mnt/sshfs/home-server/media/";
            desc = "Cd media of home server";
          }
        ]

        ++ lib.optionals (myEnv.location == "uni") [
          {
            on = [
              "g"
              "s"
              "c"
            ];
            run = "cd /mnt/sshfs/uni-cluster/cluster-share/users/bai/";
            desc = "Cd cluster-share";
          }
          {
            on = [
              "g"
              "s"
              "r"
            ];
            run = "cd /mnt/sshfs/uni-cluster/cluster-share/users/bai/storm/results/";
            desc = "Cd cluster-share results";
          }
        ];
        input.prepend_keymap = [
          {
            on = "h";
            run = "insert";
          }
        ];
      };
    };
  };
  home.sessionVariables.QT_QPA_PLATFORMTHEME = lib.mkForce "flatpak";
  xdg = {
    configFile."xdg-desktop-portal-termfilechooser/config".text =
      let
        launcherDeps = pkgs.buildEnv {
          name = "yazi-launcher-dependencies";
          paths = with pkgs; [
            coreutils
            yazi
            gnused
            bashInteractive
          ];
        };
      in
      ''
        [filechooser]
        env=PATH='${launcherDeps}/bin'
        env=TERMCMD='${lib.getExe pkgs.wezterm} start --always-new-process --class "wezterm_filechooser"'
        cmd='${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh'
        default_dir=$HOME/Downloads
      '';
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-termfilechooser
      ];
      # Override the default filechooser portal.
      config = {
        common = {
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };
        xmonad = {
          default = [
            "xmonad"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };
      };
    };
  };
}
