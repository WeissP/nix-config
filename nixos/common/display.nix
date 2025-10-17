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
        # {
        #   services.xserver.desktopManager.plasma6.enable = true;
        #   services.displayManager.sddm.enable = true;
        # }
      ]
    else if myEnv.display == "wayland" then
      [ ./niri.nix ]
    else
      [ ];
}
