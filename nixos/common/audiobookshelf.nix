{
  pkgs,
  myEnv,
  secrets,
  ...
}:
with myEnv;
{
  services.audiobookshelf = {
    enable = true;
    package = pkgs.lts.audiobookshelf;
    user = myEnv.username;
    openFirewall = true;
    # host = secrets.nodes."${configSession}".localIp;
    host = "0.0.0.0";
  };
}
