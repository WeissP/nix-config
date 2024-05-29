{ config, myEnv, secrets, lib, pkgs, ... }: {
  imports =
    [ ./aliases.nix ./nushell.nix ./zsh.nix ./tools.nix ./starship.nix ];
}
