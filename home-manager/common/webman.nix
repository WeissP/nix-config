{
  lib,
  myEnv,
  secrets,
  outputs,
  ...
}:
with myEnv;
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
              host.domain = "webman.${builtins.elemAt (builtins.attrNames secrets.persistentDomains) 0}";
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
          nodes = toNode "homeServer" "local" // toNode "Vultr" "public";
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
        (ifUsage "webman-server" {
          nodeName = "${configSession}";
          server = {
            enable = true;
            dbUrl = "postgres://${username}:${secrets.sql.localPassword}@localhost:5432/webman";
            sync =
              if configSession != "Vultr" then
                [
                  {
                    name = "Vultr";
                    interval = "1 hours";
                  }
                ]
              else
                [ ];
          };
        })
        (lib.optionalAttrs (configSession == "Vultr") {
          nodes."${configSession}" = lib.mkForce {
            host.ipv4 = secrets.nodes.Vultr.localIp;
            port = 7777;
            tls = false;
          };
        })
        (ifDarwin {
          nodes."${configSession}" = {
            host.ipv4 = "127.0.0.1";
            port = 7777;
            tls = false;
          };
          nodeName = "${configSession}";
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
            target = "${configSession}";
          };
          server = {
            enable = true;
            dbUrl = "postgres://${username}:${secrets.sql.localPassword}@localhost:5432/webman";
            sync = [
              {
                name = "Vultr";
                interval = "2 hours";
              }
            ];
          };
        })
        (ifLinuxPersonal {
          nodes."${configSession}" = {
            host.ipv4 = "127.0.0.1";
            port = 7777;
            tls = false;
          };
          nodeName = "${configSession}";
          cli = {
            provider.browsers = {
              # vivaldi.browser = "Vivaldi";
              # chromium.browser = "Chromium";
              floorp = {
                browser = "Floorp";
                location = "${homeDir}/.floorp/9zfvq2bx.default/places.sqlite";
              };
              firefox = {
                browser = "Firefox";
                location = "${homeDir}/.mozilla/firefox/oqbprr8u.default/places.sqlite";
              };
            };
            logLevel = "info";
            target =
              if location == "home" then
                "mini"
              else if (builtins.elem "webman-server" usage) then
                configSession
              else
                "Vultr";
            freq = "1min";
          };
        })

      ];
    };
}
