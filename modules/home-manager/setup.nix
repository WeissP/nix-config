{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.services.setup;
  filename = "recentf.toml";
  path = "${config.xdg.configHome}/recentf/${filename}";
  toToml = (pkgs.formats.toml { }).generate filename;
  f = pkgs.runCommand "f" { };
in {
  options.services.setup = {
    enable = mkEnableOption "setup";
    commands = with types;
      mkOption {
        type = listOf str;
        default = [ ];
      };
  };
  config = mkIf cfg.enable {
    home.file."ff".text = lib.strings.concatLines cfg.commands;
  };
}

