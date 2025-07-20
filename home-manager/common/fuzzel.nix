{
  pkgs,
  myEnv,
  lib,
  ...
}:
{
  programs.fuzzel = {
    enable = true;
  };
}
