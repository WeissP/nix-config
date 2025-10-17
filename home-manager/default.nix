{
  inputs,
  outputs,
  lib,
  myLib,
  config,
  pkgs,
  myEnv,
  secrets,
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
        remoteFiles
        ;
    };
    sharedModules = [ inputs.wired-notify.homeManagerModules.default ];
    backupFileExtension = "hm_backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${myEnv.username}" = import (./users + "/${myEnv.username}.nix");
  };
in
(
  if myEnv.arch == "linux" then
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.users."${myEnv.username}" = {
            systemd.user.targets.autostart = {
              Unit = {
                Description = "Current graphical user session";
                Documentation = "man:systemd.special(7)";
                RefuseManualStart = "no";
                StopWhenUnneeded = "no";
              };
            };
          };
        }
      ];
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
