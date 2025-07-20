{
  pkgs,
  lib,
  myEnv,
  secrets,
  config,
  inputs,
  outputs,
  ...
}:
{
  imports =
    if myEnv.display == "Xorg" then
      [
        ./xmonad.nix
      ]
    else if myEnv.display == "wayland" then
      [ ./niri.nix ]
    else
      [ ];
}
