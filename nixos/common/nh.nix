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
with myEnv;
(ifLinux {
  programs.nh = {
    enable = true;
    flake = "${homeDir}/nix-config";
    clean = {
      enable = true;
      extraArgs = if (configSession == "desktop") then "--keep-since 4d" else "--keep-since 1d";
    };
  };
  nix.gc.automatic = lib.mkForce false;
})
