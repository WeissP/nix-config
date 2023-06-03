{ inputs, outputs, lib, myEnv, myLib, config, pkgs, ... }: {
  imports = [ ../common/personal.nix ];
        programs = {
          direnv = {
            enable = true;
            nix-direnv.enable = true;
          };
        };
}
