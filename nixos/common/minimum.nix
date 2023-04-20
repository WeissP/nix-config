{ pkgs, lib, myLib, myEnv, secrets, config, inputs, outputs, ... }: {
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
          }
          (ifDarwin {
            extraOptions = "extra-platforms = aarch64-darwin x86_64-darwin";
          })
        ];

        nixpkgs = {
          overlays = [
            outputs.overlays.additions
            outputs.overlays.modifications
            outputs.overlays.weissNur
            outputs.overlays.lts
          ];
          config = { allowUnfree = true; };
        };

        users.users."${username}" = mkMerge [
          { home = homeDir; }
          (ifLinux {
            isNormalUser = true;
            openssh.authorizedKeys.keys = [ secrets.ssh."163".public ];
            hashedPassword =
              "$6$rTlWIad.TlbAKZJI$xcXjWxb5kalXYbxJM359lOIxMq3w7MkHO0sVRzgHrJSnnRhBpiwtvtFUQ.W5a4M2Gww6Q/CTiZA00ZSTRQXG80";
            extraGroups = [ "wheel" "networkmanager" ];
          })
        ];

        services = mkMerge [
          { }
          (ifDarwin { nix-daemon.enable = true; })
          (ifLinux {
            printing.enable = true;
            dbus.packages = [ pkgs.gcr ];
            pipewire = {
              enable = true;
              alsa.enable = true;
              alsa.support32Bit = true;
              pulse.enable = true;
            };
          })
        ];

        security = mkMerge [
          (ifDarwin { pam.enableSudoTouchIdAuth = true; })
          (ifLinux { rtkit.enable = true; })
        ];

        programs = mkMerge [
          { nix-index.enable = false; }
          (ifDarwin { zsh.enable = true; })
        ];

        fonts = mkMerge [
          {
            fonts = with pkgs; [
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
              sarasa-gothic
              emacs-all-the-icons-fonts
            ];
          }
          (ifLinux {
            fontDir.enable = true;
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
          variables = { LANG = "en_US.UTF-8"; };
          systemPackages = with pkgs; [
            git
            git-crypt
            vim
            cachix
            fd
            killall
            locale
            wezterm
          ];
        };

        system = mkMerge [ (ifDarwin { stateVersion = 4; }) ];
      }
      (ifLinux {
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
