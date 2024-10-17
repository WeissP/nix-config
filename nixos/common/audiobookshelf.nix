{
  pkgs,
  lib,
  myLib,
  myEnv,
  config,
  username,
  secrets,
  configSession,
  ...
}:
{
  services.audiobookshelf = {
    enable = true;
    package = pkgs.lts.audiobookshelf;
    user = myEnv.username;
    openFirewall = true;
    host = secrets.nodes."${configSession}".localIp;
  };
}
