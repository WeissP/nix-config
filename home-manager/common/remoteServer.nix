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
    ./minimum.nix
    ./webman.nix
    ./shell
    ./singboxConfig.nix
  ];

  config.home.packages = with pkgs; [ dua ];
}
