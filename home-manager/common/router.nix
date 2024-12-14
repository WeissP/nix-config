{
  inputs,
  outputs,
  myEnv,
  lib,
  config,
  pkgs,
  username,
  secrets,
  myLib,
  ...
}:
{
  imports = [
    ./singboxConfig.nix
  ];

  # config.home.packages = with pkgs; [ dua ];
}
