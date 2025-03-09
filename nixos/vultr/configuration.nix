{
  modulesPath,
  inputs,
  outputs,
  lib,
  config,
  remoteFiles,
  myEnv,
  pkgs,
  myLib,
  secrets,
  ...
}:
with myEnv;
{
  imports = [
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
 
  networking.hostName = "${username}-${configSession}";

  zramSwap.enable = true;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_11;
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
      virtualHosts =
        let
          vultrHosts = lib.attrsets.genAttrs secrets.nodes.Vultr.domains (domain: {
            addSSL = true;
            enableACME = true;
            serverName = domain;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:7777/";
              };
              "/${secrets.singbox.configServer.path}/config" = {
                proxyPass = "http://127.0.0.1:${toString secrets.singbox.configServer.port}/";
              };
            };
          });

          mkPersistentHosts =
            subdomain: mkCfg:
            lib.listToAttrs (
              map (domain: rec {
                name = if subdomain == "" then domain else "${subdomain}.${domain}";
                value = lib.mergeAttrs {
                  serverName = name;
                  addSSL = true;
                  sslCertificate = "/var/lib/nginx/certs/${domain}.crt";
                  sslCertificateKey = "/var/lib/nginx/certs/${domain}.key";
                } (mkCfg domain);
              }) (lib.attrNames secrets.persistentDomains)
            );

          webmanPersistentHosts = mkPersistentHosts "webman" (domain: {
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:7777/";
              };
            };
          });

          singboxPersistentHosts = mkPersistentHosts "singbox" (domain: {
            locations = {
              "/${secrets.singbox.configServer.path}/config" = {
                proxyPass = "http://127.0.0.1:${toString secrets.singbox.configServer.port}/";
              };
            };
          });

          rootPersistentHosts = mkPersistentHosts "" (domain: {
            locations = {
              "/".root = remoteFiles.myNixRepo + "/resources/namari-by-shapingrain/";
            };
          });

        in
        vultrHosts // webmanPersistentHosts // singboxPersistentHosts // rootPersistentHosts;
    };

  };

  systemd.services.nginx-certificates = {
    description = "Create nginx certificates";
    wantedBy = [ "nginx.service" ];
    before = [ "nginx.service" ];
    serviceConfig.Type = "oneshot";
    script =
      let
        certCommands = lib.concatStrings (
          lib.mapAttrsToList (domain: value: ''
            mkdir -p /var/lib/nginx/certs
            echo "${value.ssl.certificate}" > /var/lib/nginx/certs/${domain}.crt
            echo "${value.ssl.key}" > /var/lib/nginx/certs/${domain}.key
            chown nginx:nginx /var/lib/nginx/certs/${domain}.{crt,key}
            chmod 400 /var/lib/nginx/certs/${domain}.key
          '') secrets.persistentDomains
        );
      in
      ''
        ${certCommands}
      '';
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
