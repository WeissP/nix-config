{ pkgs, lib, myLib, myEnv, config, secrets, outputs, ... }: {
  imports = [ outputs.homeManagerModules.webman ];
  config = with myEnv; {
    programs.webman = lib.mkMerge [
      {
        enable = true;

        apiKey = secrets.webman.apiKey;
        nodes = {
          RaspberryPi = {
            host.ipv4 = secrets.nodes.RaspberryPi.ip;
            port = 7777;
            tls = false;
          };
          Vultr = {
            host.domain = secrets.nodes.Vultr.domain;
            tls = true;
          };
        };
        cli = {
          enable = true;
          logFile = "${homeDir}/.config/webman/cli.log";
          tagsFile = "${homeDir}/.config/webman/tags.yaml";
        };
        server = {
          logLevel = "normal";
          secretKey = secrets.webman.secretKey;
        };
      }
      (ifDarwin {
        nodes.MacBook = {
          host.ipv4 = "127.0.0.1";
          port = 7777;
          tls = false;
        };
        nodeName = "MacBook";
        cli = {
          provider.browsers.safari.browser = "Safari";
          logLevel = "info";
          target = "MacBook";
        };
        server = {
          enable = true;
          dbUrl =
            "postgres://${username}:${secrets.sql.password}@localhost:5432/webman";
          sync = [{
            name = "Vultr";
            interval = "5 hours";
          }];
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
          provider.browsers.daily.browser = "Chromium";
          logLevel = "info";
          target = "RaspberryPi";
          freq = "1min";
        };
        server = {
          enable = false;
          dbUrl = "postgres://postgres:postgres@localhost:7776/webman";
          sync = [{
            name = "RaspberryPi";
            interval = "600 seconds";
          }];
        };
      })
    ];
  };
}
