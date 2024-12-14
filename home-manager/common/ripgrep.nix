{
  pkgs,
  myEnv,
  myLib,
  lib,
  ...
}:
{
  programs.ripgrep = rec {
    enable = true;
    # arguments = [
    #   "--glob '!**/result/**'"
    # ];
  };
}
