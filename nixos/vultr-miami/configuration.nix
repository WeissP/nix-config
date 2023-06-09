{ inputs, outputs, lib, config, myEnv, pkgs, secrets, configSession, ... }:
with myEnv; {
  imports = [
    ../common/minimum.nix
    ../common/psql.nix
    ../common/zsh.nix
    outputs.nixosModules.v2ray
  ];
  time.timeZone = "America/New_York";
  networking.hostName = "${username}-${configSession}";

  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = secrets.email.webde;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        permitRootLogin = "prohibit-password";
        passwordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    myPostgresql = {
      enable = true;
      package = pkgs.lts.postgresql_15;
      databases = [ "webman" ];
    };
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."webman.damajiang.ga" = {
        addSSL = true;
        enableACME = true;
        locations = {
          "/".proxyPass = "http://127.0.0.1:7777";
          # "/webman".proxyPass = "http://127.0.0.1:7777";
          "${secrets.v2ray.path}" = {
            proxyPass = "http://127.0.0.1:17586";
            extraConfig = ''
              proxy_redirect off;
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
              proxy_set_header Host $host;

              sendfile on;
              tcp_nopush on;
              tcp_nodelay on;
              keepalive_requests 10000;
              keepalive_timeout 2h;
              proxy_buffering off;
            '';
          };
        };
      };
      virtualHosts."cf.damajiang.ga" = {
        addSSL = true;
        enableACME = true;
        locations = {
          # "/".proxyPass = "http://127.0.0.1:7777";
          # "/webman".proxyPass = "http://127.0.0.1:7777";
          "/ray" = {
            proxyPass = "http://127.0.0.1:17586";
            extraConfig = ''
              proxy_redirect off;
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
              proxy_set_header Host $host;

              sendfile on;
              tcp_nopush on;
              tcp_nodelay on;
              keepalive_requests 10000;
              keepalive_timeout 2h;
              proxy_buffering off;
            '';
          };
        };
      };
    };
    weissV2ray = {
      enable = true;
      config = {
        log = {
          loglevel = "info";
          access = "${homeDir}/v2ray_access.log";
          error = "${homeDir}/v2ray_error.log";
        };
        inbounds = [{
          listen = "127.0.0.1";
          port = 17586;
          protocol = "vmess";
          settings = {
            clients = [{
              id = secrets.v2ray.id;
              level = 1;
              alterId = 0;
            }];
          };
          streamSettings = {
            network = "ws";
            wsSettings = { path = secrets.v2ray.path; };
          };
        }];
        outbounds = [
          {
            protocol = "freedom";
            settings = { };
            tag = "allowed";
          }
          {
            protocol = "blackhole";
            settings = { };
            tag = "blocked";
          }
        ];
        routing = {
          rules = [{
            type = "field";
            ip = [ "geoip:private" ];
            outboundTag = "blocked";
          }];
        };
      };
    };
  };

  users.users."root".openssh.authorizedKeys.keys = [ secrets.ssh."163".public ];
  users.users."${username}" = {
    hashedPassword = secrets."${configSession}".password.hashed;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  system.stateVersion = "23.05";
}
