{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-root.url = "github:srid/flake-root";
    haskell-flake.url = "github:srid/haskell-flake";
    mission-control.url = "github:Platonic-Systems/mission-control";
  };
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.haskell-flake.flakeModule
        inputs.mission-control.flakeModule
        inputs.flake-root.flakeModule
      ];

      perSystem = { self', config, pkgs, ... }:
        let docPort = "8998";
        in {

          # Typically, you just want a single project named "default". But
          # multiple projects are also possible, each using different GHC version.
          haskellProjects.default = {
            devShell = { hlsCheck.enable = true; };
            autoWire =
              [ "packages" "apps" "checks" ]; # Wire all but the devShell
          };

          mission-control.scripts = {
            docs = {
              description = "Start Hoogle server for project dependencies";
              exec = ''
                echo http://127.0.0.1:${docPort}
                hoogle serve -p ${docPort} --local -q 
              '';
              category = "Dev Tools";
            };
            repl = {
              description = "Start the cabal repl";
              exec = ''
                cabal repl "$@"
              '';
              category = "Dev Tools";
            };
            build = {
              description = "build the project";
              exec = ''
                cabal build
              '';
              category = "Primary";
            };
          };
          # haskell-flake doesn't set the default package, but you can do it here.
          packages.default = self'.packages.myXmonad;
          devShells.default = pkgs.mkShell {
            name = "myXmonad";
            inputsFrom = [
              config.haskellProjects.default.outputs.devShell
              config.flake-root.devShell
              config.mission-control.devShell
            ];
          };
        };
    };
}
