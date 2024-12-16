{
  inputs,
  outputs,
  myEnv,
  lib,
  myLib,
  config,
  pkgs,
  ...
}:
with myEnv;
{
  imports = lib.flatten [
    ../common/minimum.nix
    (lib.optional (builtins.elem "personal" usage) ../common/personal.nix)
    (lib.optional (builtins.elem "local-server" usage) ../common/localServer.nix)
    (lib.optional (builtins.elem "remote-server" usage) ../common/remoteServer.nix)
    (lib.optional (builtins.elem "router" usage) ../common/router.nix)
  ];
  
}
