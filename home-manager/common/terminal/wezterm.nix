{ config, myEnv, pkgs, ... }:

{
  programs.wezterm.enable = true;
  home.file = let
    configDir = config.xdg.configHome;
    linuxCfg = ''config.default_prog = { "${pkgs.nushell}/bin/nu" }'';
    darwinCfg = "";
    cfg = if (myEnv.arch == "darwin") then darwinCfg else linuxCfg;
  in {
    "${configDir}/wezterm/nixed.lua".text = ''
      local config = require("common")

      ${cfg}

      return config
    '';
    "${configDir}/wezterm" = {
      source = ../config_files/wezterm;
      recursive = true;
    };
  };
}
