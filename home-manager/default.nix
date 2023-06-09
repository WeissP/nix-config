{ inputs, outputs, lib, myLib, config, pkgs, myEnv, secrets, configSession, ...
}:
let
  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs secrets myEnv myLib configSession;
    };
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${myEnv.username}" = import (./users + "/${myEnv.username}.nix");
  };
in (if myEnv.arch == "linux" then {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  config = { inherit home-manager; };
} else {
  imports = [ inputs.home-manager.darwinModules.home-manager ];
  config = { inherit home-manager; };
})
