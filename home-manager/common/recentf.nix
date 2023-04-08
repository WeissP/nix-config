{ pkgs, lib, myLib, config, username, secrets, ... }:
let
  homeDir = myLib.homeDir username;
  nodes = secrets.nodes;
  toTramps = nodeNames:
    lib.attrsets.genAttrs nodeNames
    (name: (lib.attrsets.getAttr name nodes).ip);
in {
  programs.recentf = {
    enable = true;
    tramps = toTramps [ "RaspberryPi" "Vultr" ];
    databaseUrl = "postgres://${username}@localhost/recentf";
    filters = [
      { name_prefix = "COMMIT_EDITMSG"; }
      {
        dir_prefix = "${homeDir}/Documents/Org-roam/daily";
        ext = "org";
        name_prefix = "Ʀ";
      }
      {
        dir_prefix = "${homeDir}/.emacs.d/emacs-config/config";
        ext = "el";
      }
      { dir_prefix = "${homeDir}/.emacs.d/straight/build"; }
      {
        dir_prefix = "${homeDir}/.password-store";
        ext = "gpg";
      }
    ];
  };
  systemd.user.services.recentf = myLib.service.startup {
    cmds = ''
      echo "SELECT 'CREATE DATABASE recentf' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'recentf')\gexec" | psql'';
  };
}

