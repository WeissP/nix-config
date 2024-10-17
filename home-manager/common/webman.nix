{
  pkgs,
  lib,
  myLib,
  myEnv,
  config,
  secrets,
  outputs,
  configSession,
  ...
}:
{
  imports = [ outputs.homeManagerModules.webman ];
  config =
    let
      toNode =
        name: tag:
        lib.genAttrs [ name ] (
          name:
          if tag == "local" then
            {
              host.ipv4 = lib.attrsets.getAttrFromPath [
                "nodes"
                name
                "localIp"
              ] secrets;
              port = 7777;
              tls = false;
            }
          else if tag == "public" then
            {
              host.domain = "${builtins.elemAt (lib.attrsets.getAttrFromPath [
                "nodes"
                name
                "domains"
              ] secrets) 0}";
              tls = true;
            }
          else
            { }
        );
    in
    with myEnv;
    {
      programs.webman = lib.mkMerge [
        {
          enable = true;
          apiKey = secrets.webman.apiKey;
          nodes = toNode "RaspberryPi" "local" // toNode "Vultr" "public";
          server = {
            logLevel = "normal";
            secretKey = secrets.webman.secretKey;
          };
        }
        (ifPersonal {
          cli = {
            enable = true;
            logFile = "${homeDir}/.config/webman/cli.log";
            tagsFile = "${homeDir}/.config/webman/tags.yaml";
          };
        })
        (ifServer {
          nodeName = "${configSession}";
          cli.enable = false;
          server = {
            enable = true;
            dbUrl = "postgres://${username}:${secrets.sql.localPassword}@localhost:5432/webman";
            sync =
              if configSession != "RaspberryPi" then
                [
                  {
                    name = "Vultr";
                    interval = "5 hours";
                  }
                ]
              else
                [ ];
          };
        })
        (lib.optionalAttrs (configSession == "Vultr") {
          nodes."${configSession}" = lib.mkForce {
            host.ipv4 = lib.attrsets.getAttrFromPath [
              "nodes"
              configSession
              "localIp"
            ] secrets;
            port = 7777;
            tls = false;
          };
        })
        (ifDarwin {
          nodes.MacBook = {
            host.ipv4 = "127.0.0.1";
            port = 7777;
            tls = false;
          };
          nodeName = "MacBook";
          cli = {
            provider.browsers = {
              safari = {
                browser = "Safari";
                # location = "${homeDir}/.config/webman/History.db";
              };
              firefox = {
                browser = "Firefox";
                location = "${homeDir}/Library/Application Support/Firefox/Profiles/qr5u59ie.default-release/places.sqlite";
              };
            };
            logLevel = "info";
            target = "MacBook";
          };
          server = {
            enable = true;
            dbUrl = "postgres://${username}:${secrets.sql.localPassword}@localhost:5432/webman";
            sync = [
              {
                name = "Vultr";
                interval = "5 hours";
              }
            ];
          };
        })
        (ifLinuxPersonal {
          nodes.Desktop = {
            host.ipv4 = "127.0.0.1";
            port = 7777;
            tls = false;
          };
          nodeName = "Desktop";
          cli = {
            provider.browsers = {
              vivaldi.browser = "Vivaldi";
              chromium.browser = "Chromium";
              firefox.browser = "Firefox";
            };
            logLevel = "info";
            target = "RaspberryPi";
            freq = "1min";
          };
          server = {
            enable = false;
            dbUrl = "postgres://postgres:postgres@localhost:7776/webman";
            sync = [
              {
                name = "RaspberryPi";
                interval = "600 seconds";
              }
            ];
          };
        })
      ];
    };
}
