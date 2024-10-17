{
  pkgs,
  lib,
  myLib,
  myEnv,
  config,
  username,
  ...
}:
{
  services.jellyfin = {
    enable = true;
    package = pkgs.lts.jellyfin;
    user = myEnv.username;
    openFirewall = true;
  };
  environment.systemPackages = with pkgs.lts;[
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
}

