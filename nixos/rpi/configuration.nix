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
    # ../common/jellyfin.nix
    ../common/audiobookshelf.nix
    ../common/sing-box.nix
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
    ntp.enable = true;
    myPostgresql = {
      enable = true;
      package = pkgs.lts.postgresql_15;
    };
    getty.autologinUser = "${username}";
    devmon.enable = true;
    udisks2.enable = true;
    dnsmasq = {
      enable = false;
      alwaysKeepRunning = false;
      settings = {
        # domain-needed = true;
        interface = "end0";
        bind-interfaces = true;
        dhcp-range = [ "192.168.0.2,192.168.0.254" ];
        dhcp-host = [ "14:85:7f:b9:8c:eb,192.168.0.38" ];
        dhcp-option = [ "3,192.168.0.1" ];
      };
    };
  };

  # boot.kernel.sysctl = {
  #   "net.ipv4.ip_forward" = 1;
  # };

  networking = {
    # useDHCP = false;
    # defaultGateway = {
    #   address = "192.168.0.1";
    #   interface = "end0";
    # };
    # interfaces.end0 = {
    #   useDHCP = false;
    #   ipv4.addresses = [
    #     {
    #       address = "192.168.0.31";
    #       prefixLength = 24;
    #     }
    #   ];
    # };
    firewall = {
      enable = false;
      allowedTCPPorts = [
        2017
        6800
        6881
        7777
        80
        443
      ];
    };
  };

  networking.hostName = "rpi";
}
