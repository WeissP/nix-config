{
  pkgs,
  lib,
  myLib,
  myEnv,
  ...
}:
{
  home.packages = [
    pkgs.handlr
    # shadowing xdg-open
    (pkgs.writeShellScriptBin "xdg-open" ''
      ${lib.getExe pkgs.handlr} open "$@"
    '')
  ];
}
