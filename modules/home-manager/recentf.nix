{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.programs.recentf;
  filename = "recentf.toml";
  path = "${config.xdg.configHome}/recentf/${filename}";
  toToml = (pkgs.formats.toml { }).generate filename;
  f = pkgs.runCommand "f" { };
in {
  options.programs.recentf = {
    enable = mkEnableOption "recentf";
    tramps = with types;
      mkOption {
        type = attrsOf str;
        default = { };
      };
    databaseUrl = with types;
      mkOption {
        type = str;
        default = "postgres://postgres@localhost/recentf";
      };
    searchLimit = with types;
      mkOption {
        type = int;
        default = 30;
      };
    filters = with types;
      mkOption {
        type = with types;
          listOf (submodule {
            options = lib.attrsets.genAttrs [
              "name_prefix"
              "dir_prefix"
              "ext"
              "name_suffix"
            ] (k:
              mkOption {
                type = str;
                default = "";
              });
          });
        default = [ ];
      };
  };
  config = mkIf cfg.enable {
    xdg.configFile."recentf/${filename}".source = toToml {
      tramp_aliases = cfg.tramps;
      database.url = cfg.databaseUrl;
      search.limit = cfg.searchLimit;
      filter = cfg.filters;
    };
    home.packages = [ pkgs.recentf ];
  };

}
