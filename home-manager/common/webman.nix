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
          enable = true;
          logLevel = "normal";
          reactLocation = pkgs.fetchFromGitHub {
            owner = "WeissP";
            repo = "webman";
            rev = "fe4660c9256729b64b4fe37d5fb39312cf018586";
            sha256 = "sha256-J5CbEY0oRqf2CcMghA/+SG1JTcqTQvD+wxy+W4uSFzo=";
          } + "/webman-cljs/resources/public/";
          limits.msgpack = "20 MiB";
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
          dbUrl =
            "postgres://${username}:${secrets.password}@localhost:5432/webman";
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
          provider.browsers.safari.browser = "Chromium";
          logLevel = "info";
          target = "RaspberryPi";
        };
        server = {
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
