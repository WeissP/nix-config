{
  lib,
  myEnv,
  secrets,
  ...
}:
with myEnv;
{
  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings = {
      Address = secrets.nodes."${configSession}".localIp;
      MusicFolder = "/media/audios/music";
      Scanner.Schedule = "@every 2h";
    };
  };
}
