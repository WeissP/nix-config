{ config, myEnv, secrets, lib, pkgs, ... }:
with myEnv; {
  programs.nushell = lib.mkMerge [{
    enable = true;
    configFile.text = ''
      $env.config = {
         show_banner: false
      }
    '';
  }];
}
