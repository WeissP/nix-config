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
  programs.mpv = {
    enable = true;
    scripts = with pkgs; [
      additions.mpv-bookmarker
      additions.mpv-thumbfast
      mpvScripts.uosc
    ];
    config = {
      osc = "no";
      osd-bar = "no";
      border = "no";
      save-position-on-quit = "yes";
    };
    bindings =
      let
        forwards = {
          f = 3;
          g = 8;
          r = 50;
          t = 600;
        };
        backwards = {
          s = 2;
          a = 6;
          w = 45;
          q = 500;
        };
      in
      myLib.mergeAttrList [
        (builtins.mapAttrs (key: value: "seek ${toString value} exact") forwards)
        (builtins.mapAttrs (key: value: "seek -${toString value} exact") backwards)
        {
          v = "show-progress";
          d = "add volume -5";
          e = "add volume 5";
          x = "quit";
          B = "script_message bookmarker-menu";
          b = "script_message bookmarker-quick-save";
          j = "multiply speed 1.1";
          k = "multiply speed 0.9";
          BS = "set speed 1.0";
          i = "add audio-delay -0.100";
          l = "add audio-delay 0.100";
          LEFT = "add sub-delay -0.1";
          RIGHT = "add sub-delay +0.1";
          "ctrl+b" = "script_message bookmarker-quick-load";
        }
      ];
  };
}
