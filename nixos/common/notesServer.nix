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
  services.meilisearch = {
    enable = true;
    listenAddress = secrets.nodes."${myEnv.configSession}".localIp;
  };
}
