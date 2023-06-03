{ pkgs, lib, myEnv, ... }:
with myEnv;
lib.mkMerge [
  {
    programs = { zsh.enable = true; };
    environment = {
      shells = [ pkgs.zsh ];
      pathsToLink = [ "/share/zsh" ];
    };
  }
  (ifLinux { users.defaultUserShell = pkgs.zsh; })
]
