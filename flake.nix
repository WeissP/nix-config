{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-lts.url = "github:nixos/nixpkgs/nixos-25.05";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wired-notify.url = "github:Toqozz/wired-notify";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.home-manager.follows = "home-manager";
    };
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix?ref=v0.4.1";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
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
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    myNixRepo = {
      url = "github:WeissP/nix-config";
      flake = false;
    };
    weissXmonad.url = "github:WeissP/weiss-xmonad";
    # weissXmonad.url = "/home/weiss/projects/weiss-xmonad";
    hledger-importer.url = "github:WeissP/hledger-importer";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    nuScripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };
    consult = {
      url = "github:minad/consult";
      flake = false;
    };
    consult-omni = {
      url = "github:armindarvish/consult-omni";
      flake = false;
    };
    embark = {
      url = "github:oantolin/embark";
      flake = false;
    };
    citar = {
      url = "github:emacs-citar/citar";
      flake = false;
    };
    aider-el = {
      url = "github:tninja/aider.el";
      flake = false;
    };
    flyover = {
      url = "github:konrad1977/flyover";
      flake = false;
    };
    gptel-prompts = {
      url = "github:jwiegley/gptel-prompts";
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
      darwinEnv = {
        arch = "darwin";
        username = "bozhoubai";
      };
      linuxEnv = {
        arch = "linux";
        username = "weiss";
      };
      mkSpecialArgs =
        env: extra:
        assert (myLib.validateEnv extra);
        {
          inherit
            inputs
            outputs
            secrets
            myLib
            ;
          myEnv = myLib.expandEnv (extra // env);
          remoteFiles = with inputs; {
            inherit
              myNixRepo
              citar
              embark
              nuScripts
              consult
              consult-omni
              aider-el
              flyover
              gptel-prompts
              ;
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
        (import ./pkgs {
          inherit pkgs myLib secrets;
        })
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
      overlays = import ./overlays { inherit inputs myLib secrets; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations =
        let
          baseModules = [
            disko.nixosModules.disko
            inputs.nur.modules.nixos.default
            ./home-manager
          ];
          desktopModules = baseModules ++ [
            # inputs.niri.nixosModules.niri
            ./disko/btrfs_system.nix
            nixosModules.picom
            inputs.stylix.nixosModules.stylix
            nixosModules.xmonadBin
          ];
        in
        {
          desktop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = mkSpecialArgs linuxEnv {
              usage = [
                "personal"
                "webman-server"
                "daily"
              ];
              mainScreen = "DisplayPort-1";
              mainDevice = "/dev/nvme0n1";
              swapSize = "48GB";
              configSession = "desktop";
              location = "home";
              display = "Xorg";
            };
            modules = desktopModules ++ [
              ./nixos/desktop/hardware-configuration.nix
              ./nixos/desktop/configuration.nix
              # { boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; }
            ];
          };

          uni = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = mkSpecialArgs linuxEnv {
              usage = [
                "personal"
                "webman-server"
              ];
              mainScreen = "HDMI-0";
              mainDevice = "/dev/sda";
              configSession = "uni";
              location = "uni";
              display = "Xorg";
            };
            modules = desktopModules ++ [
              ./nixos/uni/hardware-configuration.nix
              ./nixos/uni/configuration.nix
            ];
          };

          mini = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = mkSpecialArgs linuxEnv {
              configSession = "mini";
              mainScreen = "HDMI-1";
              location = "uni";
              mainDevice = "/dev/nvme0n1";
              usage = [
                "personal"
                "webman-server"
                "daily"
              ];
              display = "Xorg";
            };
            modules = desktopModules ++ [
              ./nixos/mini/hardware-configuration.nix
              ./nixos/mini/configuration.nix
            ];
          };

          laptop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = mkSpecialArgs linuxEnv {
              configSession = "laptop";
              usage = [
                "personal"
                "webman-server"
                "daily"
              ];
              mainScreen = "DisplayPort-1";
              mainDevice = "/dev/nvme0n1";
              swapSize = "48GB";
              location = "home";
              display = "wayland";
              # display = "Xorg";
            };
            modules = desktopModules ++ [
              ./nixos/laptop/hardware-configuration.nix
              ./nixos/laptop/configuration.nix
              (
                { modulesPath, ... }:
                {
                  imports = [ (modulesPath + "/virtualisation/qemu-vm.nix") ];
                  virtualisation.qemu.options = [
                    "-device virtio-vga-gl"
                    "-display gtk,gl=on"
                  ];
                }
              )
            ];
          };

          homeServer = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = mkSpecialArgs linuxEnv {
              configSession = "homeServer";
              location = "home";
              mainDevice = "/dev/nvme0n1";
              hdd4t = "/dev/disk/by-id/ata-WDC_WD40EFPX-68C6CN0_WD-WX92D25D7417";
              hddMediaArray = {
                hdd1 = "/dev/disk/by-id/ata-WDC_WD80EFPX-68C4ZN0_WD-RD255EDH";
                hdd2 = "/dev/disk/by-id/ata-WDC_WD80EFPX-68C4ZN0_WD-RD2579RH";
              };
              hddMediaParityArray = {
                parity1 = "/dev/disk/by-id/ata-ST8000VN004-3CP101_WP01VWR3";
              };
              usage = [
                "webman-server"
                "local-server"
                "aria-server"
              ];
              display = "none";
            };
            modules = baseModules ++ [
              ./disko/home_server.nix
              ./nixos/homeServer/hardware-configuration.nix
              ./nixos/homeServer/configuration.nix
            ];
          };

          vultr = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = mkSpecialArgs linuxEnv {
              configSession = "Vultr";
              location = "japan";
              usage = [
                "remote-server"
                "webman-server"
                "syncthing-relay-server"
              ];
              display = "none";
            };
            modules = baseModules ++ [
              ./nixos/vultr/configuration.nix
            ];
          };

          rpi = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            specialArgs = mkSpecialArgs linuxEnv {
              configSession = "RaspberryPi";
              location = "home";
              usage = [
                "local-server"
                "webman-server"
                "aria-server"
              ];
              display = "none";
            };
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
            specialArgs = mkSpecialArgs linuxEnv {
              configSession = "installer";
              usage = [ ];
              location = "china";
              display = "Xorg";
            };
            modules = [
              ./nixos/installer/installer.nix
            ];
          }).config.system.build.isoImage;
        installer =
          (nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = mkSpecialArgs linuxEnv {
              configSession = "installer";
              usage = [ ];
              location = "home";
              display = "Xorg";
            };
            modules = [
              ./nixos/installer/installer.nix
            ];
          }).config.system.build.isoImage;
      };

      vm = {
        laptop = nixosConfigurations.laptop.config.system.build.vm;
        desktop = nixosConfigurations.desktop.config.system.build.vm;
      };

      darwinConfigurations = {
        Bozhous-Air = inputs.darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = mkSpecialArgs darwinEnv {
            configSession = "Bozhous-Air";
            location = "home";
            usage = [
              "webman-server"
            ];
          };
          modules = [
            ./nixos/mac/configuration.nix
            ./home-manager
          ];
        };
      };

      deploy =
        let
          activate = forAllSystems (
            system:
            (import nixpkgs {
              inherit system;
              overlays = [
                deploy-rs.overlays.default
                (self: super: {
                  deploy-rs = {
                    inherit (import nixpkgs { inherit system; }) deploy-rs;
                    lib = super.deploy-rs.lib;
                  };
                })
              ];
            }).deploy-rs.lib.activate
          );
        in
        {
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
                  path = activate.x86_64-linux.nixos self.nixosConfigurations."vultr";
                };
              };
            };
            "rpi" = {
              hostname = secrets.nodes."RaspberryPi".localIp;
              profiles = {
                system = {
                  path = activate.aarch64-linux.nixos self.nixosConfigurations."rpi";
                };
              };
            };
            "mini" = {
              hostname = secrets.nodes."mini".localIp;
              profiles = {
                system = {
                  path = activate.x86_64-linux.nixos self.nixosConfigurations."mini";
                };
              };
            };
            "homeServer" = {
              hostname = secrets.nodes.homeServer.localIp;
              profiles = {
                system = {
                  path = activate.x86_64-linux.nixos self.nixosConfigurations."homeServer";
                };
              };
            };
          };
        };
    };
}
