{
  modulesPath,
  inputs,
  outputs,
  lib,
  config,
  myEnv,
  pkgs,
  myLib,
  secrets,
  configSession,
  ...
}:
with myEnv;
{
  imports = [
    # (modulesPath + "/installer/scan/not-detected.nix")
    # (modulesPath + "/profiles/qemu-guest.nix")
    # ./disk-config.nix
    ./hardware-configuration.nix
    ../common/minimum.nix
    ../common/psql.nix
    ../common/zsh.nix
    ../common/syncthing.nix
    ../common/sing-box.nix
  ];

  nix.gc = {
    options = lib.mkForce "--delete-older-than 1d";
  };

  time.timeZone = "Japan";
  # time.timeZone = secrets.v2ray.vmessLinks."/vmess_links_subscription/1";
  networking.hostName = "${username}-${configSession}";

  zramSwap.enable = true;
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # boot.loader.grub = {
  #   # no need to set devices, disko will add all devices that have a EF02 partition to the list already
  #   # devices = [ ];
  #   efiSupport = true;
  #   efiInstallAsRemovable = true;
  # };
  security.acme = {
    acceptTerms = true;
    defaults.email = secrets.email.webde;
  };

  services = {
    getty.autologinUser = "${username}";
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = true;
      };
    };
    myPostgresql = {
      enable = true;
      package = pkgs.lts.postgresql_15;
    };

    nginx = {
      enable = true;
      defaultSSLListenPort = secrets.nginx.tlsPort;
      logError = "/var/log/nginx/error.log info";
      recommendedProxySettings = false;
      recommendedTlsSettings = false;
      sslProtocols = "TLSv1 TLSv1.1 TLSv1.2 TLSv1.3";
      virtualHosts = (
        lib.attrsets.genAttrs secrets.nodes.Vultr.domains (domain: {
          addSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:7777/";
            };
            "/webman".proxyPass = "http://127.0.0.1:7777/";
            "/${secrets.singbox.configServer.path}/config" = {
              proxyPass = "http://127.0.0.1:${toString secrets.singbox.configServer.port}/";
            };
          };
        })
      );
    };

  };

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [
      53

    ];
    allowedTCPPorts = [
      80
      443

    ];
  };

  system.stateVersion = "23.11";
}
