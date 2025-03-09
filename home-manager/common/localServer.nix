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
    ./aria.nix
    ./videosDownloader.nix
  ];

  config.home.packages = with pkgs; [
    dua
    lux
  ];
}
