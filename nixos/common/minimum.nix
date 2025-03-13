{
  pkgs,
  lib,
  myEnv,
  secrets,
  config,
  inputs,
  outputs,
  ...
}:
{
  imports =
    let
      importUsage =
        attrs: lib.flatten (lib.attrValues (lib.filterAttrs (key: _: builtins.elem key myEnv.usage) attrs));
    in
    [
      ./location.nix
    ]
    ++ importUsage {
      local-server = [
        ./jellyfin.nix
        ./audiobookshelf.nix
      ];
      personal = ./personal.nix;
      webman-server = ./psql.nix;
    };
  config =
    with lib;
    with myEnv;
    mkMerge [
      {
        nix = mkMerge [
          {
            settings = mkMerge [
              {
                experimental-features = "nix-command flakes";
                substituters =
                  if (location == "china") then
                    [
                      "https://mirrors.ustc.edu.cn/nix-channels/store?priority=10"
                      "https://mirror.sjtu.edu.cn/nix-channels/store?priority=10"
                      "https://nix-community.cachix.org?priority=20"
                      "https://cache.nixos.org?priority=30"
                      "https://cache.iog.io?priority=30"
                    ]
                  else
                    [
                      "https://nix-community.cachix.org"
                      "https://cache.nixos.org/"
                      "https://cache.iog.io"
                    ];
                trusted-substituters = [
                  "https://weiss.cachix.org"
                  "https://nix-community.cachix.org"
                  "https://cache.nixos.org/"
                  "https://cache.iog.io"
                ];
                trusted-public-keys = [
                  "weiss.cachix.org-1:2IzFIzVwv8/iIrmz319mWB0KDqGl16eoNF67eX1YNdo="
                  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                  "sylvorg.cachix.org-1:xd1jb7cDkzX+D+Wqt6TemzkJH9u9esXEFu1yaR9p8H8="
                  "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" # haskell
                ];
              }
              (ifLinux {
                auto-optimise-store = true;
                trusted-users = [
                  "root"
                  "${username}"
                ];
              })
            ];

            gc = {
              automatic = true;
            };
          }
          (ifDarwin {
            gc = {
              interval = {
                Hour = 23;
              };
              options = "--delete-older-than 1d";
            };
            extraOptions = ''
              extra-platforms = aarch64-darwin x86_64-darwin
              keep-outputs = false
              keep-derivations = false
            '';
          })
          (ifLinux {
            # This will add each flake input as a registry
            # To make nix3 commands consistent with your flake
            registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

            # This will additionally add your inputs to the system's legacy channels
            # Making legacy nix commands consistent as well, awesome!
            nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
          })
          (ifLinuxPersonal {
            extraOptions = ''
              keep-outputs = true
              keep-derivations = true
            '';
            gc = {
              dates = "daily";
              options = "--delete-older-than 4d";
            };
          })
          (ifServer {
            gc = {
              dates = "daily";
              options = "--delete-older-than 1d";
            };
          })
        ];

        nixpkgs = {
          overlays = [
            outputs.overlays.additions
            outputs.overlays.modifications
            outputs.overlays.lts
            outputs.overlays.pinnedUnstables
            (import inputs.emacs-overlay)
            # (import (
            #   builtins.fetchTarball {
            #     url = "https://github.com/nix-community/emacs-overlay/archive/87e8ffccb53aa67dfaab7bd4fd9f27b543e73cec.tar.gz";
            #   }
            # ))
          ];
          config = {
            allowUnfree = true;
          };
        };

        users.users."${username}" = mkMerge [
          { home = homeDir; }
          (ifLinux {
            isNormalUser = true;
            openssh.authorizedKeys.keys = [ secrets.ssh."163".public ];
            extraGroups = [
              "wheel"
              "networkmanager"
              "input"
              "storage"
              "docker"
            ];
          })
        ];

        # programs = {
        #   gnupg = {
        #     agent = {
        #       enable = true;
        #       pinentryPackage = pkgs.pinentry-gnome3;
        #     };
        #   };
        # };

        services = mkMerge [
          { }
          (ifLinux {
            ntp.enable = true;
            getty.autologinUser = "${username}";
            printing.enable = true;
            dbus.packages = [ pkgs.gcr ];
            udisks2.enable = true;
          })
        ];

        security = mkMerge [
          (ifDarwin { pam.services.sudo_local.touchIdAuth = true; })
          (ifLinux { rtkit.enable = true; })
        ];

        environment = {
          variables = {
            LANG = "en_US.UTF-8";
          };
          systemPackages = with pkgs; [
            vim
            git
            lsof
          ];
        };

        system = mkMerge [ (ifDarwin { stateVersion = 4; }) ];
      }

      (ifServer {
        services.openssh = {
          enable = true;
          settings = {
            PermitRootLogin = "prohibit-password";
            PasswordAuthentication = true;
            KbdInteractiveAuthentication = true;
          };
        };
      })
      (ifLinux {
        users = {
          mutableUsers = false;
          users = {
            "root" = {
              openssh.authorizedKeys.keys = secrets.ssh."163".authorizedKeys;
              hashedPassword = secrets.nodes."${configSession}".password.hashed;
              # password = secrets.nodes."${configSession}".password.raw;
            };
            "${username}" = {
              openssh.authorizedKeys.keys = secrets.ssh."163".authorizedKeys;
              # password = secrets.nodes."${configSession}".password.raw;
              hashedPassword = secrets.nodes."${configSession}".password.hashed;
            };
          };
        };
        networking = {
          networkmanager.enable = true;
        };
        boot.initrd.systemd.enable = true;
        environment.systemPackages = with pkgs; [ util-linux ];
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
      (optionalAttrs (builtins.elem "webman-server" usage) {
        services.myPostgresql = {
          enable = true;
        };
      })
    ];

}
