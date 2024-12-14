{
  inputs,
  outputs,
  lib,
  myLib,
  config,
  pkgs,
  myEnv,
  secrets,
  configSession,
  remoteFiles,
  ...
}:
let
  home-manager = {
    extraSpecialArgs = {
      inherit
        inputs
        outputs
        secrets
        myEnv
        myLib
        configSession
        remoteFiles
        ;
    };
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${myEnv.username}" = import (./users + "/${myEnv.username}.nix");
  };
in
(
  if myEnv.arch == "linux" then
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      config = {
        inherit home-manager;
      };
    }
  else
    {
      imports = [
        inputs.home-manager.darwinModules.home-manager
        { nixpkgs.overlays = [ inputs.nixpkgs-firefox-darwin.overlay ]; }
      ];
      config = {
        inherit home-manager;
      };
    }
)
