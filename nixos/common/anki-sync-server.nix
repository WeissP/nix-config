{
  inputs,
  outputs,
  lib,
  myEnv,
  config,
  secrets,
  pkgs,
  ...
}:
{
  services.anki-sync-server = with myEnv; {
    enable = true;
    address = secrets.nodes."${configSession}".localIp;
    port = 27701;
    openFirewall = true;
    users = [
      {
        inherit (myEnv) username;
        password = configSession;
      }
    ];
  };
}
