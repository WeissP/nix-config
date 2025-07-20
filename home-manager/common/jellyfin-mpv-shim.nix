{
  inputs,
  outputs,
  lib,
  myEnv,
  config,
  pkgs,
  myLib,
  ...
}:
{
  services.jellyfin-mpv-shim = {
    enable = true;
    mpvBindings = config.programs.mpv.bindings;
    mpvConfig = config.programs.mpv.config;
    settings = {
      enable_gui = false;
      enable_osc = false;
      kb_fullscreen = "null";
      kb_kill_shader = "null";
      kb_watched = "null";
      client_uuid = "73fbc087-6b12-4c0a-8e16-94008f826c46";
      mpv_ext = false;
      thumbnail_osc_builtin = false;
    };
  };
  xdg.configFile = {
    "jellyfin-mpv-shim/scripts/uosc" = {
      source = "${pkgs.mpvScripts.uosc}/share/mpv/scripts/uosc";
      recursive = true;
    };
    "jellyfin-mpv-shim/fonts" = {
      source = "${pkgs.mpvScripts.uosc}/share/fonts";
      recursive = true;
    };
    "jellyfin-mpv-shim/scripts/thumbfast.lua".source =
      "${pkgs.mpvScripts.thumbfast}/share/mpv/scripts/thumbfast.lua";
  };
}
