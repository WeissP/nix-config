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
  imports =
    if usage == "personal" then
      [ ../common/personal.nix ]
    else if usage == "server" then
      [ ../common/server.nix ]
    else
      [ ../common/minimum.nix ];

  services.pueue.enable = true;
}
