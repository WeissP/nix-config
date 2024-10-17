{
  pkgs,
  lib,
  myLib,
  myEnv,
  config,
  ...
}:
with lib;
with myEnv;
let
  cfg = config.programs.webman;
  filename = "webman.toml";
  dir = "${config.xdg.configHome}/webman";
  path = "${dir}/${filename}";
  toToml = (pkgs.formats.toml { }).generate filename;
  optionalString = cond: text: if cond then text else "";
  optionalList = cond: list: if cond then list else [ ];
in
{
  options.programs.webman = {
    enable = mkEnableOption "webman";
    nodeName = with types; mkOption { type = str; };
    apiKey = with types; mkOption { type = str; };
    nodes =
      with types;
      mkOption {
        type = attrsOf anything;
        default = { };
      };
    cli = mkOption {
      default = {
        enable = false;
      };
      type =
        with types;
        submodule {
          options = {
            enable = mkEnableOption "webman-cli";
            logLevel = mkOption {
              type = enum [
                "error"
                "warn"
                "info"
                "debug"
                "trace"
              ];
              default = "info";
            };
            logFile = mkOption {
              type = str;
              default = "/var/log/webman/cli.log";
            };
            target = mkOption {
              type = str;
              default = "";
            };
            tagsFile = mkOption {
              type = str;
              default = "";
            };
            provider = mkOption {
              type = attrsOf anything;
              default = { };
            };
            freq = mkOption { type = str; };
          };
        };
    };
    server = mkOption {
      default = {
        enable = false;
      };
      type =
        with types;
        submodule {
          options = {
            enable = mkEnableOption "webman-server";
            logLevel = mkOption {
              type = enum [
                "critical"
                "normal"
                "debug"
                "off"
              ];
              default = "normal";
            };
            reactLocation = mkOption {
              type = str;
              default =
                pkgs.fetchFromGitHub {
                  owner = "WeissP";
                  repo = "webman";
                  rev = "fe4660c9256729b64b4fe37d5fb39312cf018586";
                  sha256 = "sha256-J5CbEY0oRqf2CcMghA/+SG1JTcqTQvD+wxy+W4uSFzo=";
                }
                + "/webman-cljs/resources/public/";
            };
            limits = mkOption {
              type = attrsOf str;
              default = {
                msgpack = "20 MiB";
              };
            };
            dbUrl = mkOption {
              type = str;
              default = "";
            };
            secretKey = mkOption {
              type = str;
              default = "";
            };
            sync = mkOption {
              default = [ ];
              type = listOf (submodule {
                options = {
                  name = mkOption { type = str; };
                  interval = mkOption { type = str; };
                };
              });
            };
          };
        };
    };
  };
  config = mkIf cfg.enable (
    lib.mkMerge [
      {
        xdg = {
          enable = true;
          configFile."webman/${filename}".source = toToml {
            Global = {
              name = cfg.nodeName;
              "api_key" = cfg.apiKey;
              nodes = cfg.nodes;
            };
            cli = {
              log_level = cfg.cli.logLevel;
              log_file = cfg.cli.logFile;
              target = cfg.cli.target;
              tags_file = cfg.cli.tagsFile;
              provider = cfg.cli.provider;
            };
            server = {
              log_level = cfg.server.logLevel;
              react_location = cfg.server.reactLocation;
              limits = cfg.server.limits;
              databases.webman.url = cfg.server.dbUrl;
              secret_key = cfg.server.secretKey;
              sync = cfg.server.sync;
            };
          };
        };
      }
      (mkIf cfg.server.enable { home.packages = [ pkgs.webman.webman-server ]; })
      (mkIf (cfg.server.enable && arch == "linux") {
        home = {
          sessionVariables = {
            SCRIPTS_DIR = myEnv.scriptsDir;
          };
          file = {
            "${homeDir}/scripts/ensure_psql_db.sh" = {
              source = myLib.withConfigDir "/scripts/ensure_psql_db.sh";
            };
            "${homeDir}/scripts/start_webman_server.sh" = {
              executable = true;
              text = "${pkgs.webman.webman-server.outPath}/bin/webman-server > ~/webman.log";
            };
          };
        };
        systemd.user = {
          services."ensure-webman-db" = myEnv.ensurePsqlDb "webman";
          services.webman-server = myLib.service.startup {
            cmds = "${pkgs.bash}/bin/bash ${scriptsDir}/start_webman_server.sh";
            wantedBy = [ ];
            description = "webman-server";
          };
          # webman-server must start after network is up, however, network-online.target is not triggered if there is no network-manager installed
          timers.webman-server-starter = {
            Unit.Description = "Start webman-server";
            Timer = {
              OnBootSec = "30s";
              Unit = "webman-server.service";
            };
            Install = {
              WantedBy = [ "timers.target" ];
            };
          };
        };
      })
      (mkIf cfg.cli.enable {
        home.packages = [ pkgs.webman.webman-cli ];
        systemd.user = {
          services.webman-cli-provider = {
            Unit.Description = "provide local browser history to nodes via webman-cli";
            Service = {
              ExecStart = "${pkgs.webman.webman-cli.outPath}/bin/webman-cli provide";
            };
          };
          timers.webman-cli-provider = {
            Unit.Description = "provide local browser history to nodes via webman-cli";

            Timer = {
              OnBootSec = "5s";
              OnUnitActiveSec = cfg.cli.freq;
              Unit = "webman-cli-provider.service";
            };
            Install = {
              WantedBy = [ "timers.target" ];
            };
          };
        };
      })
    ]
  );
}
