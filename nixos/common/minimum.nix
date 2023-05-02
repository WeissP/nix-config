{ pkgs, lib, myLib, myEnv, secrets, config, inputs, outputs, configSession, ...
}: {
  imports = [ ./syncthing.nix ];
  config = with lib;
    with myEnv;
    mkMerge [
      {
        nix = mkMerge [
          {
            # This will add each flake input as a registry
            # To make nix3 commands consistent with your flake
            registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

            # This will additionally add your inputs to the system's legacy channels
            # Making legacy nix commands consistent as well, awesome!
            nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
              config.nix.registry;

            settings = mkMerge [
              {
                experimental-features = "nix-command flakes";
                auto-optimise-store = false;
              }
              (ifLinux { trusted-users = [ "root" "${username}" ]; })
            ];

            extraOptions = ''
              keep-outputs = true
              keep-derivations = true
            '';
          }
          (ifDarwin {
            extraOptions = ''
              extra-platforms = aarch64-darwin x86_64-darwin
              keep-outputs = true
              keep-derivations = true
            '';
          })
        ];

        nixpkgs = {
          overlays = [
            outputs.overlays.additions
            outputs.overlays.modifications
            outputs.overlays.weissNur
            outputs.overlays.lts
            (import inputs.emacs-overlay)
          ];
          config = { allowUnfree = true; };
        };

        users.users."${username}" = mkMerge [
          { home = homeDir; }
          (ifLinux {
            isNormalUser = true;
            openssh.authorizedKeys.keys = [ secrets.ssh."163".public ];
            extraGroups = [ "wheel" "networkmanager" "input" ];
          })
        ];

        services = mkMerge [
          { }
          (ifDarwin { nix-daemon.enable = true; })
          (ifLinux {
            printing.enable = true;
            dbus.packages = [ pkgs.gcr ];
            udisks2.enable = true;
          })
        ];

        security = mkMerge [
          (ifDarwin { pam.enableSudoTouchIdAuth = true; })
          (ifLinux { rtkit.enable = true; })
        ];

        programs = {
          nix-index.enable = false;
          zsh.enable = true;
        };

        fonts = mkMerge [
          {
            fontDir.enable = true;
            fonts = with pkgs; [
              route159
              noto-fonts
              noto-fonts-cjk
              noto-fonts-emoji
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
                sansSerif =
                  [ "Noto Sans CJK SC" "Source Han Sans SC" "DejaVu Sans" ];
                serif =
                  [ "Noto Serif CJK SC" "Source Han Serif SC" "DejaVu Serif" ];
              };
            };
          })
        ];

        environment = {
          shells = [ pkgs.zsh ];
          pathsToLink = [ "/share/zsh" ];
          variables = { LANG = "en_US.UTF-8"; };
          systemPackages = with pkgs; [
            git
            git-crypt
            ripgrep
            vim
            cachix
            fd
            killall
            locale
            wezterm
            babashka
            unzip
            zip
          ];
        };

        system = mkMerge [ (ifDarwin { stateVersion = 4; }) ];
      }
      (ifLinux {
        users.defaultUserShell = pkgs.zsh;
        environment.systemPackages = with pkgs; [ udisks util-linux ];
        networking.networkmanager.enable = true;
        i18n = {
          defaultLocale = "en_US.UTF-8";
          extraLocaleSettings = {
            LC_ADDRESS = "de_DE.UTF-8";
            LC_IDENTIFICATION = "de_DE.UTF-8";
            LC_MEASUREMENT = "de_DE.UTF-8";
            LC_MONETARY = "de_DE.UTF-8";
            LC_NAME = "de_DE.UTF-8";
            LC_NUMERIC = "de_DE.UTF-8";
            LC_PAPER = "de_DE.UTF-8";
            LC_TELEPHONE = "de_DE.UTF-8";
            LC_TIME = "de_DE.UTF-8";
          };
        };
      })
    ];

}
