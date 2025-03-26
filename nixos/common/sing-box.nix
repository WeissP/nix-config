{
  pkgs,
  myEnv,
  lib,
  secrets,
  ...
}:
with myEnv;
let
  pkg = pkgs.sing-box;
  singboxService = name: singboxCfg: {
    serviceConfig = {
      StateDirectory = "sing-box";
      StateDirectoryMode = "0700";
      RuntimeDirectory = "sing-box";
      RuntimeDirectoryMode = "0700";
      ExecStart =
        let
          cfg = pkgs.writeTextFile {
            name = "${name}.json";
            text = builtins.toJSON singboxCfg;
          };
        in
        [
          ""
          "${lib.getExe pkg} -D \${STATE_DIRECTORY} -c ${cfg} run"
        ];
    };
    wantedBy = [ "multi-user.target" ];
  };
in
lib.mkMerge [
  {
    environment.systemPackages = [ pkg ];
  }
  (lib.optionalAttrs (location == "china" && arch == "linux") {
    systemd.packages = [ pkg ];
    systemd.services.sing-box = singboxService "tunCn" secrets.singbox.config.tunCn;
  })
  (lib.optionalAttrs (location == "home" && configSession == "desktop") {
    systemd.packages = [ pkg ];
    systemd.services.sing-box = singboxService "tunDe" secrets.singbox.config.tunDe;
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
  })
]
