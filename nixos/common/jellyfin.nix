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

  systemd.user.services.metatube-server = {
    description = "MetaTube Server";
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      StateDirectory = "metatube-server";
      WorkingDirectory = "%S/metatube-server";
      ExecStart = "${lib.getExe pkgs.additions.metatube-server} -dsn metatube.db -port 19875";
      Restart = "on-failure";
    };
  };

  environment.systemPackages = with pkgs.lts; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    pkgs.additions.metatube-server
  ];
}
