{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-lts.url = "github:nixos/nixpkgs/nixos-22.11";

    weissNur = {
      url = "github:WeissP/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    recentf = { url = "github:WeissP/recentf"; };
  };

  outputs = { self, nixpkgs, home-manager, deploy-rs, ... }@inputs:
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
    in rec {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; });
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
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        vmware = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets myLib; };
          modules = [
            # > Our main nixos configuration file <
            ./nixos/vmware/configuration.nix
          ];
        };
      };

      # home-manager.backupFileExtension = "backup";

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "weiss@desktop" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs secrets myLib;
            username = "weiss";
          };
          modules = [
            # > Our main home-manager configuration file <
            ./home-manager/weiss.nix
          ];
        };
        "test" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs secrets myLib;
            username = "weiss";
          };
          modules = [
            # > Our main home-manager configuration file <
            ./home-manager/test.nix
          ];
        };
      };

      deploy = {
        sshUser = "root";
        user = "root";
        sshOpts = [ "-p" "22" ];

        autoRollback = false;
        magicRollback = false;

        nodes = {
          "root" = {
            hostname = "172.16.76.128";
            profiles = {
              system = {
                path = deploy-rs.lib.x86_64-linux.activate.nixos
                  self.nixosConfigurations."vmware";
              };
              weiss = {
                # sshUser = "weiss";
                path = deploy-rs.lib.x86_64-linux.activate.home-manager
                  self.homeConfigurations."weiss@desktop";
                user = "weiss";
              };
            };
          };
        };
      };
    };
}
