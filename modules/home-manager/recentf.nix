{
  pkgs,
  myEnv,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.programs.recentf;
  filename = "recentf.toml";
  path = "${config.xdg.configHome}/recentf/${filename}";
  toToml = (pkgs.formats.toml { }).generate filename;
in
{
  options.programs.recentf = {
    enable = mkEnableOption "recentf";
    tramps =
      with types;
      mkOption {
        type = attrsOf str;
        default = { };
      };
    databaseUrl =
      with types;
      mkOption {
        type = str;
        default = "postgres://postgres@localhost/recentf";
      };
    searchLimit =
      with types;
      mkOption {
        type = int;
        default = 30;
      };
    filters =
      with types;
      mkOption {
        type =
          with types;
          listOf (submodule {
            options =
              lib.attrsets.genAttrs
                [
                  "name_prefix"
                  "dir_prefix"
                  "ext"
                  "name_suffix"
                  "name_regex"
                ]
                (
                  k:
                  mkOption {
                    type = nullOr str;
                    default = null;
                  }
                );
          });
        default = [ ];
      };
    cleanFreq = with types; mkOption { type = str; };
  };
  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      configFile."recentf/${filename}".source = toToml {
        tramp_aliases = cfg.tramps;
        database.url = cfg.databaseUrl;
        search.limit = cfg.searchLimit;
        filter = map (attrs: lib.attrsets.filterAttrs (n: v: v != null) attrs) cfg.filters;
      };
    };
    home.packages = [ pkgs.recentf ];
    systemd.user = {
      services."ensure-recentf-db" = myEnv.ensurePsqlDb "recentf";
      services.recentf-clean = {
        Unit.Description = "clean unexists recent files";
        Service = {
          ExecStart = "${pkgs.recentf.outPath}/bin/recentf clean";
        };
      };
      timers.recentf-clean = {
        Unit.Description = "clean unexists recent files";
        Timer = {
          OnBootSec = "5s";
          OnUnitActiveSec = cfg.cleanFreq;
          Unit = "webman-cli-provider.service";
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };
    };
  };
}
