{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-lts.url = "github:nixos/nixpkgs/nixos-22.11";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    weissNur = {
      url = "github:WeissP/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    recentf = { url = "github:WeissP/recentf"; };
    webman = { url = "github:WeissP/webman"; };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    { self, nixpkgs, home-manager, nixos-generators, deploy-rs, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      secrets = import ./secrets;
      myLib = import ./myLib {
        lib = nixpkgs.lib;
        pkgs = nixpkgs;
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
        inherit inputs outputs secrets myLib;
        myEnv = env;
      };
    in rec {

      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in (import ./pkgs { inherit pkgs; }) // {
          qemu = nixos-generators.nixosGenerate {
            inherit system;
            specialArgs = {
              inherit inputs outputs secrets myLib;
              myEnv = linuxEnv;
            };
            format = "vm";
            modules = [ ./nixos/desktop/configuration.nix ./home-manager ];
          };
          image = nixos-generators.nixosGenerate {
            inherit system;
            specialArgs = {
              inherit inputs outputs secrets myLib;
              myEnv = linuxEnv;
            };
            format = "install-iso";
            modules = [ ./nixos/desktop/configuration.nix ./home-manager ];
          };

        });
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; });

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
            inherit inputs outputs secrets myLib;
            myEnv = linuxEnv;
            configSession = "desktop";
          };
          modules = [
            ./nixos/desktop/configuration.nix
            ./nixos/desktop/hardware-configuration.nix
            inputs.nur.nixosModules.nur
            ./home-manager
          ];
        };

        vultr-miami = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs secrets myLib;
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
      };

      darwinConfigurations = let myEnv = darwinEnv;
      in {
        Bozhous-Air = inputs.darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs outputs secrets myLib myEnv;
            configSession = "Bozhous-Air";
          };
          modules = [
            ./nixos/mac/configuration.nix
            ./home-manager

            # (homeConfig darwinEnv (import ./home-manager/mac.nix))
            # darwinHome
            # home-manager.darwinModules.home-manager
            # {
            #   home-manager.extraSpecialArgs = {
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
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs secrets;
            myEnv = linuxEnv;
          };
          modules = [ ./home-manager/weiss.nix ];
        };
        "test" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs secrets myLib;
            myEnv = linuxEnv;
          };
          modules = [ ./home-manager/test.nix ];
        };

        "mac" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs secrets myLib;
            myEnv = darwinEnv;
          };
          modules = [ ./home-manager/mac.nix ];
        };
      };

      deploy = {
        user = "root";
        sshUser = "root";
        sshOpts = [ "-p" "22" ];

        autoRollback = false;
        magicRollback = false;

        nodes = {
          "vultr-miami" = {
            hostname = secrets."vultr-miami".ip;
            profiles = {
              system = {
                path = deploy-rs.lib.x86_64-linux.activate.nixos
                  self.nixosConfigurations."vultr-miami";
              };
            };
          };
        };
      };
    };
}
