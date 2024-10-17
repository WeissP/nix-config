{
  modulesPath,
  inputs,
  outputs,
  lib,
  config,
  myEnv,
  pkgs,
  secrets,
  configSession,
  ...
}:
with myEnv;
{
  imports = [
    ../common/minimum.nix
    ../common/psql.nix
    ../common/zsh.nix
    ../common/syncthing.nix
    ../common/jellyfin.nix
    ../common/audiobookshelf.nix
  ];

  # fileSystems."/run/media/weiss/575b3fc0-13fc-4db2-bdd0-bbccb66f83b3" = {
  #   device = "/dev/disk/by-uuid/575b3fc0-13fc-4db2-bdd0-bbccb66f83b3";
  #   options = [
  #     "uid=1000"
  #     "gid=100"
  #     "dmask=007"
  #     "fmask=117"
  #     "nofail"
  #     "x-systemd.automount"
  #   ];
  # };

  time.timeZone = "Europe/Berlin";
  environment.systemPackages = with pkgs; [
    vim
    git
  ];
  services = {
    myPostgresql = {
      enable = true;
      package = pkgs.lts.postgresql_15;
    };
    getty.autologinUser = "${username}";
    devmon.enable = true;
    udisks2.enable = true;
  };
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [
      6800
      6881
      7777
      80
      443
    ];
  };

  networking.hostName = "rpi";
}
