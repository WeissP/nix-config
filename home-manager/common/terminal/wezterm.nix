{ config, myEnv, ... }:

{
  programs.wezterm.enable = true;
  home.file = let configDir = config.xdg.configHome;
  in {
    "${configDir}/wezterm" = {
      source = ../config_files/wezterm;
      recursive = true;
    };
  };
}
