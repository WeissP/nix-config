{
  pkgs,
  myEnv,
  myLib,
  lib,
  secrets,
  configSession,
  ...
}:
let
  pkg = pkgs.sing-box;
in
with myEnv;
lib.mkMerge [
  {
    environment.systemPackages = [ pkg ];
  }
  (ifRouter {
    systemd.packages = [ pkg ];
    systemd.services.sing-box = {
      serviceConfig = {
        StateDirectory = "sing-box";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "sing-box";
        RuntimeDirectoryMode = "0700";
        ExecStart = [
          ""
          "${lib.getExe pkg} -D \${STATE_DIRECTORY} -c ${singboxCfgDir}/routerDe.json run"
        ];
      };
      wantedBy = [ "multi-user.target" ];
    };
  })
  (ifRemoteServer {
    boot.kernelPatches = [
      {
        name = "bbr";
        patch = null;
        extraStructuredConfig = with pkgs.lib.kernel; {
          TCP_CONG_BBR = yes; # enable BBR
          DEFAULT_BBR = yes; # use it by default
        };
      }
    ];
    services.static-web-server = {
      enable = true;
      listen = "[::]:${toString secrets.singbox.configServer.port}";
      root = "${singboxCfgDir}";
    };
    systemd = {
      packages = [ pkg ];
      services.sing-box = {
        serviceConfig = {
          StateDirectory = "sing-box";
          StateDirectoryMode = "0700";
          RuntimeDirectory = "sing-box";
          RuntimeDirectoryMode = "0700";
          ExecStart = [
            ""
            "${lib.getExe pkg} -D \${STATE_DIRECTORY} -c ${singboxCfgDir}/server.json run"
          ];
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
  })
]
