{ pkgs, lib, myLib, myEnv, config, ... }:
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
in {
  options.programs.webman = {
    enable = mkEnableOption "webman";
    nodeName = with types; mkOption { type = str; };
    apiKey = with types; mkOption { type = str; };
    nodes = with types;
      mkOption {
        type = attrsOf anything;
        default = { };
      };
    cli = mkOption {
      default = { enable = false; };
      type = with types;
        submodule {
          options = {
            enable = mkEnableOption "webman-cli";
            logLevel = mkOption {
              type = enum [ "error" "warn" "info" "debug" "trace" ];
              default = "info";
            };
            logFile = mkOption { type = str; };
            target = mkOption { type = str; };
            tagsFile = mkOption { type = str; };
            provider = mkOption { type = attrsOf anything; };
          };
        };
    };
    server = mkOption {
      default = { enable = false; };
      type = with types;
        submodule {
          options = {
            enable = mkEnableOption "webman-server";
            logLevel = mkOption {
              type = enum [ "critical" "normal" "debug" "off" ];
              default = "normal";
            };
            reactLocation = mkOption { type = str; };
            limits = mkOption { type = attrsOf str; };
            dbUrl = mkOption { type = str; };
            secretKey = mkOption { type = str; };
            sync = mkOption {
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
  config = mkIf cfg.enable (lib.mkMerge [{
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
    home.packages = [ ]
      ++ (optionalList cfg.server.enable [ pkgs.webman.webman-server ])
      ++ (optionalList cfg.cli.enable [ pkgs.webman.webman-cli ]);
  }]);
}

