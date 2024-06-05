{ inputs, outputs, myEnv, lib, myLib, config, pkgs, ... }:
with myEnv; {
  imports = if usage == "personal" then
    [ ../common/personal.nix ]
  else if usage == "server" then [
    ../common/minimum.nix
    ../common/webman.nix
    ../common/shell.nix
  ] else
    [ ../common/minimum.nix ];

  services.pueue.enable = true;
}
