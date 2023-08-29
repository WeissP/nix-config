{ pkgs, lib, myLib, myEnv, secrets, config, inputs, outputs, configSession, ...
}: {
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
                auto-optimise-store = true;
                substituters = [
                  "https://nix-community.cachix.org"
                  "https://cache.nixos.org/"
                  "https://cache.iog.io"
                ];
                trusted-public-keys = [
                  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                  "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" # haskell
                ];
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
          config = {
            allowUnfree = true;
            # permittedInsecurePackages = [ "openssl-1.1.1u" ];
          };
        };

        users.users."${username}" = mkMerge [
          { home = homeDir; }
          (ifLinux {
            isNormalUser = true;
            openssh.authorizedKeys.keys = [ secrets.ssh."163".public ];
            extraGroups = [ "wheel" "networkmanager" "input" "storage" ];
          })
        ];

        services = mkMerge [
          { }
          (ifDarwin { nix-daemon.enable = true; })
          (ifLinux {
            ntp.enable = true;
            printing.enable = true;
            dbus.packages = [ pkgs.gcr ];
            udisks2.enable = true;
          })
        ];

        security = mkMerge [
          (ifDarwin { pam.enableSudoTouchIdAuth = true; })
          (ifLinux { rtkit.enable = true; })
        ];

        environment = {
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
            unzip
            zip
          ];
        };

        system = mkMerge [ (ifDarwin { stateVersion = 4; }) ];
      }

      (ifLinux {
        environment.systemPackages = with pkgs; [ util-linux ];
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
