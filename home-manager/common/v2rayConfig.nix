{
  pkgs,
  myEnv,
  myLib,
  lib,
  # builtins,
  secrets,
  config,
  ...
}:
{
  home =
    let
      genRouteConfig = domain: path: id: {
        inbounds = [
          {
            tag = "transparent";
            port = 12345;
            protocol = "dokodemo-door";
            settings = {
              network = "tcp,udp";
              followRedirect = true;
            };
            sniffing = {
              enabled = true;
              destOverride = [
                "http"
                "tls"
              ];
            };
            streamSettings = {
              sockopt = {
                tproxy = "tproxy";
                mark = 255;
              };
            };
          }
          {
            port = 1080;
            protocol = "socks";
            sniffing = {
              enabled = true;
              destOverride = [
                "http"
                "tls"
              ];
            };
            settings = {
              auth = "noauth";
            };
          }
        ];

        outbounds = [
          {
            tag = "proxy";
            protocol = "vmess";
            settings = {
              vnext = [
                {
                  address = domain;
                  port = 443;
                  security = "aes-128-gcm";
                  users = [
                    {
                      id = id;
                      alterId = 0;
                    }
                  ];
                }
              ];
            };
            streamSettings = {
              network = "ws";
              security = "tls";
              tlsSettings = {
                alpn = [ "HTTP/1.1" ];
                serverName = domain;
              };
              wsSettings = {
                headers = {
                  Host = domain;
                };
                path = path;
              };
              xtlsSettings = {
                alpn = [ "HTTP/1.1" ];
                serverName = domain;
              };
              sockopt.mark = 255;
            };
            mux.enabled = true;
          }
          {
            tag = "direct";
            protocol = "freedom";
            settings.domainStrategy = "UseIP";
            streamSettings.sockopt.mark = 255;
          }
          {
            tag = "block";
            protocol = "blackhole";
            settings.response.type = "http";
          }
          {
            tag = "dns-out";
            protocol = "dns";
            streamSettings.sockopt.mark = 255;
          }
        ];

        dns.servers = [
          {
            address = "223.5.5.5";
            port = 53;
            domains = [
              "geosite:cn"
              "ntp.org"
              domain
            ];
          }
          {
            address = "114.114.114.114";
            port = 53;
            domains = [
              "geosite:cn"
              "ntp.org"
              domain
            ];
          }
          {
            address = "8.8.8.8";
            port = 53;
            domains = [ "geosite:geolocation-!cn" ];
          }
          {
            address = "1.1.1.1";
            port = 53;
            domains = [ "geosite:geolocation-!cn" ];
          }
        ];

        routing = {
          domainStrategy = "IPOnDemand";
          rules = [
            {
              type = "field";
              inboundTag = [ "transparent" ];
              port = 53;
              network = "udp";
              outboundTag = "dns-out";
            }
            {
              type = "field";
              inboundTag = [ "transparent" ];
              port = 123;
              network = "udp";
              outboundTag = "direct";
            }
            {
              type = "field";
              ip = [
                "223.5.5.5"
                "114.114.114.114"
              ];
              outboundTag = "direct";
            }
            {
              type = "field";
              ip = [
                "8.8.8.8"
                "1.1.1.1"
              ];
              outboundTag = "proxy";
            }
            {
              type = "field";
              domain = [ "geosite:category-ads-all" ];
              outboundTag = "block";
            }
            {
              type = "field";
              protocol = [ "bittorrent" ];
              outboundTag = "direct";
            }
            {
              type = "field";
              ip = [
                "geoip:private"
                "geoip:cn"
              ];
              outboundTag = "direct";
            }
            {
              type = "field";
              domain = [ "geosite:cn" ];
              outboundTag = "direct";
            }
          ];
        };
      };
      genConfig = domain: path: id: {
        inbounds = [
          {
            port = 1080;
            listen = "127.0.0.1";
            protocol = "socks";
            sniffing = {
              enabled = true;
              destOverride = [
                "http"
                "tls"
              ];
            };
            settings = {
              auth = "noauth";
              udp = true;
            };
          }
        ];

        outbounds = [
          {
            protocol = "vmess";
            settings = {
              vnext = [
                {
                  address = domain;
                  port = 443;
                  security = "aes-128-gcm";
                  users = [
                    {
                      id = id;
                      alterId = 0;
                    }
                  ];
                }
              ];
            };
            streamSettings = {
              network = "ws";
              security = "tls";
              tlsSettings = {
                alpn = [ "HTTP/1.1" ];
                serverName = domain;
              };
              wsSettings = {
                headers = {
                  Host = domain;
                };
                path = path;
              };
              xtlsSettings = {
                alpn = [ "HTTP/1.1" ];
                serverName = domain;
              };
            };
            tag = "wss";
          }
          {
            protocol = "freedom";
            settings = { };
            tag = "direct";
          }
        ];

        routing = {
          domainStrategy = "IPOnDemand";
          rules = [
            {
              type = "field";
              outboundTag = "direct";
              domain = [ "geosite:cn" ];
            }
            {
              type = "field";
              outboundTag = "direct";
              ip = [
                "geoip:cn"
                "geoip:private"
              ];
            }
          ];
        };
      };
    in
    {
      file =
        builtins.listToAttrs (
          map (domain: {
            name = "${config.xdg.configHome}/v2ray_config/client/${domain}.json";
            value = {
              text = builtins.toJSON (genConfig domain secrets.v2ray.path secrets.v2ray.id);
            };
          }) secrets.nodes.Vultr.domains
        )
        // builtins.listToAttrs (
          map (domain: {
            name = "${config.xdg.configHome}/v2ray_config/route/${domain}.json";
            value = {
              text = builtins.toJSON (genRouteConfig domain secrets.v2ray.path secrets.v2ray.id);
            };
          }) secrets.nodes.Vultr.domains
        );

    };

}
