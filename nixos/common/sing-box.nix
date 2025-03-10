{
  pkgs,
  myEnv,
  lib,
  secrets,
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
  (lib.optionalAttrs (location == "china" && arch == "linux") {
    systemd.packages = [ pkg ];
    systemd.services.sing-box = {
      serviceConfig = {
        StateDirectory = "sing-box";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "sing-box";
        RuntimeDirectoryMode = "0700";
        ExecStart =
          let
            cfg = pkgs.writeTextFile {
              name = "tunCn.json";
              text = builtins.toJSON secrets.singbox.config.tunCn;
            };
          in
          [
            ""
            "${lib.getExe pkg} -D \${STATE_DIRECTORY} -c ${cfg} run"
          ];
      };
      wantedBy = [ "multi-user.target" ];
    };
  })
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
    # systemd = {
    #   packages = [ pkg ];
    #   services.sing-box = {
    #     serviceConfig = {
    #       StateDirectory = "sing-box";
    #       StateDirectoryMode = "0700";
    #       RuntimeDirectory = "sing-box";
    #       RuntimeDirectoryMode = "0700";
    #       ExecStart = [
    #         ""
    #         "${lib.getExe pkg} -D \${STATE_DIRECTORY} -c ${singboxCfgDir}/server.json run"
    #       ];
    #     };
    #     wantedBy = [ "multi-user.target" ];
    #   };
    # };
  })
]
