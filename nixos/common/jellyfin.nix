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
    # package = pkgs.pinnedUnstables."2024-10-11".jellyfin;
    package = pkgs.lts.jellyfin;
    user = myEnv.username;
    openFirewall = true;
  };

  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  systemd.user.services.metatube-server = {
    description = "MetaTube Server";
    after = [ "network.target" ];

    serviceConfig = {
      Type = "exec";
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
