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
      User = "sing-box";
      Group = "sing-box";
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
    users = {
      users.sing-box = {
        isSystemUser = true;
        group = "sing-box";
      };
      groups.sing-box = { };
    };
  }
  (lib.optionalAttrs (location == "china" && arch == "linux") {
    systemd.packages = [ pkg ];
    systemd.services.sing-box = singboxService "tunCn" secrets.singbox.config.tunCn;
  })
  (lib.optionalAttrs (location == "home" && configSession == "desktop") {
    systemd.packages = [ pkg ];
    systemd.services.sing-box = singboxService "tunDeDesktop" secrets.singbox.config.tunDeDesktop;
  })
  (lib.optionalAttrs (location == "home" && configSession == "homeServer") {
    systemd.packages = [ pkg ];
    systemd.services.sing-box = singboxService "tunDeHomeServer" secrets.singbox.config.tunDeHomeServer;
  })
  (lib.optionalAttrs (configSession == "mini") {
    systemd.packages = [ pkg ];
    systemd.services.sing-box = singboxService "tunDeDesktop" secrets.singbox.config.tunDeHomeServer;
  })
  (ifRemoteServer {
    systemd.packages = [ pkg ];
    systemd.services.sing-box = singboxService "server" secrets.singbox.config.server;
    boot.kernelPatches = [
      {
        name = "bbr";
        patch = null;
        structuredExtraConfig = with pkgs.lib.kernel; {
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
