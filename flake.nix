{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-lts.url = "github:nixos/nixpkgs/nixos-23.11";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    weissNur = {
      url = "github:WeissP/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    recentf = {
      url = "github:WeissP/recentf";
    };
    webman = {
      url = "github:WeissP/webman";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nur.url = "github:nix-community/NUR";
    myNixRepo.url = "github:WeissP/nix-config";
    weissXmonad.url = "github:WeissP/weiss-xmonad";
    # weissXmonad.url = "/home/weiss/projects/weiss-xmonad/";
    hledger-importer.url = "github:WeissP/hledger-importer";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
  };

  nixConfig = {
    # Adapted From: https://github.com/divnix/digga/blob/main/examples/devos/flake.nix#L4
    extra-substituters = "https://cache.nixos.org https://nix-community.cachix.org https://sylvorg.cachix.org";
    extra-trusted-public-keys = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= sylvorg.cachix.org-1:xd1jb7cDkzX+D+Wqt6TemzkJH9u9esXEFu1yaR9p8H8=";
    extra-experimental-features = "nix-command flakes";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-generators,
      deploy-rs,
      disko,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      myLib = import ./myLib {
        lib = nixpkgs.lib;
        pkgs = nixpkgs;
        myNixRepo = inputs.myNixRepo;
      };
      secrets = import ./secrets {
        inherit myLib;
        lib = nixpkgs.lib;
      };
      darwinEnv = myLib.genEnv {
        arch = "darwin";
        usage = "personal";
        username = "bozhoubai";
      };
      linuxEnv = myLib.genEnv {
        arch = "linux";
        usage = "personal";
        username = "weiss";
      };
      specialArgs = env: {
        inherit
          inputs
          outputs
          secrets
          myLib
          ;
        myEnv = env;
      };
    in
    rec {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        (import ./pkgs { inherit pkgs; })
        // {
          qemu = nixos-generators.nixosGenerate {
            inherit system;
            specialArgs = {
              inherit
                inputs
                outputs
                secrets
                myLib
                ;
              myEnv = linuxEnv;
            };
            format = "vm";
            modules = [
              ./nixos/desktop/configuration.nix
              ./home-manager
            ];
          };
          image = nixos-generators.nixosGenerate {
            inherit system;
            specialArgs = {
              inherit
                inputs
                outputs
                secrets
                myLib
                ;
              myEnv = linuxEnv;
            };
            format = "install-iso";
            modules = [
              ./nixos/desktop/configuration.nix
              ./home-manager
            ];
          };

        }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./shell.nix { inherit pkgs; }
      );

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              inputs
              outputs
              secrets
              myLib
              ;
            myEnv = linuxEnv;
            configSession = "desktop";
          };
          modules = [
            nixosModules.xmonadBin
            ./nixos/desktop/configuration.nix
            ./nixos/desktop/hardware-configuration.nix
            inputs.nur.nixosModules.nur
            ./home-manager
            { boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; }
          ];
        };

        vultr-miami = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              inputs
              outputs
              secrets
              myLib
              ;
            myEnv = myLib.genEnv {
              arch = "linux";
              usage = "server";
              username = "weiss";
            };
            configSession = "vultr-miami";
          };
          modules = [
            ./nixos/vultr-miami/configuration.nix
            ./nixos/vultr-miami/hardware-configuration.nix
            ./home-manager
          ];
        };

        vultr = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              inputs
              outputs
              secrets
              myLib
              ;
            myEnv = myLib.genEnv {
              arch = "linux";
              usage = "server";
              username = "weiss";
            };
            configSession = "vultr";
          };
          modules = [
            disko.nixosModules.disko
            ./nixos/vultr/configuration.nix
            # ./nixos/vultr/hardware-configuration.nix
            ./home-manager
          ];
        };

        rpi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit
              inputs
              outputs
              secrets
              myLib
              ;
            myEnv = myLib.genEnv {
              arch = "linux";
              usage = "server";
              username = "weiss";
            };
            configSession = "rpi";
          };
          modules = [

            ./nixos/rpi/base.nix
            ./nixos/rpi/configuration.nix
            # ./home-manager
          ];
        };
      };

      darwinConfigurations =
        let
          myEnv = darwinEnv;
        in
        {
          Bozhous-Air = inputs.darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs = {
              inherit
                inputs
                outputs
                secrets
                myLib
                myEnv
                ;
              configSession = "Bozhous-Air";
            };
            modules = [
              ./nixos/mac/configuration.nix
              ./home-manager

              # (homeConfig darwinEnv (import ./home-manager/mac.nix))
              # darwinHome
              # home-manager.darwinModules.home-manager
              # {
              #   home-manager.extrpiecialArgs = {
              #     inherit inputs outputs secrets;
              #     myEnv = darwinEnv;
              #   };
              #   home-manager.useGlobalPkgs = true;
              #   home-manager.useUserPackages = true;
              #   home-manager.users."${darwinEnv.username}" =
              # import ./home-manager/mac.nix;
              # }
            ];
          };
        };

      homeConfigurations = {
        "weiss@desktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extrpiecialArgs = {
            inherit inputs outputs secrets;
            myEnv = linuxEnv;
          };
          modules = [ ./home-manager/weiss.nix ];
        };
        "test" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extrpiecialArgs = {
            inherit
              inputs
              outputs
              secrets
              myLib
              ;
            myEnv = linuxEnv;
          };
          modules = [ ./home-manager/test.nix ];
        };

        "mac" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
          extrpiecialArgs = {
            inherit
              inputs
              outputs
              secrets
              myLib
              ;
            myEnv = darwinEnv;
          };
          modules = [ ./home-manager/mac.nix ];
        };
      };

      deploy = {
        user = "root";
        sshUser = "root";
        sshOpts = [
          "-p"
          "22"
        ];

        autoRollback = false;
        magicRollback = false;

        nodes = {
          # "vultr" = {
          #   hostname = secrets."vultr".ip;
          #   profiles = {
          #     system = {
          #       path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."vultr";
          #     };
          #   };
          # };
          "rpi" = {
            hostname = "192.168.0.31";
            profiles = {
              system = {
                sshUser = "nixos";
                magicRollback = false;
                user = "nixos";
                path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations."rpi";
              };
            };
          };
        };
      };
    };
}
