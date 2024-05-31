{ config, myEnv, pkgs, ... }:

{
  programs.wezterm.enable = true;
  home.file = let configDir = config.xdg.configHome;
  in {
    "${configDir}/wezterm/nixed.lua".text = ''
      local config = require("common")

      config.default_prog = { "${pkgs.nushell}/bin/nu" }

      return config
    '';
    "${configDir}/wezterm" = {
      source = ../config_files/wezterm;
      recursive = true;
    };
  };
}
