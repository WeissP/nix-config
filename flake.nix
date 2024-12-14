{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-lts.url = "github:nixos/nixpkgs/nixos-24.11";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    raspberry-pi-nix.url = "git+https://github.com/nix-community/raspberry-pi-nix.git?tag=0.4.1";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    recentf = {
      url = "github:WeissP/recentf";
    };
    webman = {
      url = "github:WeissP/webman";
      # url = "/home/weiss/projects/webman/";
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
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    myNixRepo = {
      url = "github:WeissP/nix-config";
      flake = false;
    };
    weissXmonad.url = "github:WeissP/weiss-xmonad";
    # weissXmonad.url = "/home/weiss/projects/weiss-xmonad/";
    hledger-importer.url = "github:WeissP/hledger-importer";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    nuScripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };
    nix-alien.url = "github:thiagokokada/nix-alien";
    nixos-installer-gen.url = "gitlab:GenericNerdyUsername/nixos-installer-gen";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-generators,
      deploy-rs,
      disko,
      nixos-installer-gen,
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
        usage = [ "personal" ];
        username = "bozhoubai";
      };
      linuxEnv = myLib.genEnv {
        arch = "linux";
        usage = [ "personal" ];
        username = "weiss";
      };
      vultrEnv = myLib.genEnv {
        arch = "linux";
        usage = [ "remote-server" ];
        username = "weiss";
      };
      rpiEnv = myLib.genEnv {
        arch = "linux";
        usage = [
          "local-server"
          # "router"
        ];
        username = "weiss";
      };
      mkSpecialArgs = configSession: env: {
        inherit
          inputs
          outputs
          secrets
          myLib
          configSession
          ;
        myEnv = env;
        remoteFiles = with inputs; {
          inherit nuScripts chatgpt-shell;
        };
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
            specialArgs = mkSpecialArgs "Desktop" linuxEnv;
            format = "vm";
            modules = [
              ./nixos/desktop/configuration.nix
              ./home-manager
            ];
          };
          image = nixos-generators.nixosGenerate {
            inherit system;
            specialArgs = mkSpecialArgs "Desktop" linuxEnv;
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
        Desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = mkSpecialArgs "Desktop" linuxEnv;
          modules = [
            nixosModules.xmonadBin
            nixosModules.private-gpt
            ./nixos/desktop/configuration.nix
            ./nixos/desktop/hardware-configuration.nix
            inputs.nur.modules.nixos.default
            ./home-manager
            { boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; }
          ];
        };

        vultr = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = mkSpecialArgs "Vultr" vultrEnv;
          modules = [
            disko.nixosModules.disko
            # ./nixos/vultr/exp.nix
            ./nixos/vultr/configuration.nix
            ./home-manager
          ];
        };

        rpi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = mkSpecialArgs "RaspberryPi" rpiEnv;
          modules = [
            ./nixos/rpi/base.nix
            ./nixos/rpi/configuration.nix
            ./home-manager
          ];
        };
      };

      images = {
        rpi = nixosConfigurations.rpi.config.system.build.sdImage;
        installerCn =
          (nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = mkSpecialArgs "Desktop" linuxEnv;
            modules = [
              ./nixos/installer.nix
            ];
          }).config.system.build.isoImage;

        desktop =
          (nixos-installer-gen.generateInstaller {
            inputFlake = self; # Inputs of this flake will be copied to the store to allow offline evaluation
            includeSrc = true; # Include most tarballs used to compile the closure of targetConfig
            # Most runtime deps of this config will be copied to the installer (some need to be added manually)
            targetConfig = nixosConfigurations.Desktop;
            modules = [
              # Extra modules to add to the installer
              {
                # Reduce compression. For docs, see
                # https://github.com/NixOS/nixpkgs/blob/50f9b3107a09ed35bbf3f9ab36ad2683619debd2/nixos/lib/make-squashfs.nix#L8
                # or
                # https://github.com/NixOS/nixpkgs/blob/50f9b3107a09ed35bbf3f9ab36ad2683619debd2/nixos/modules/installer/cd-dvd/iso-image.nix#L477
                # isoImage.squashfsCompression = "zstd -Xcompression-level 6";
                nixpkgs.config.allowUnfree = true;
              }
            ];
          }).iso;
      };

      darwinConfigurations = {
        Bozhous-Air = inputs.darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = mkSpecialArgs "Bozhous-Air" darwinEnv;
          modules = [
            ./nixos/mac/configuration.nix
            ./home-manager
          ];
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
          "vultr" = {
            hostname = secrets.nodes."Vultr".publicIp;
            profiles = {
              system = {
                path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."vultr";
              };
            };
          };
          "rpi" = {
            hostname = secrets.nodes."RaspberryPi".localIp;
            profiles = {
              system = {
                path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations."rpi";
              };
            };
          };
        };
      };
    };
}
