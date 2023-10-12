{ pkgs, lib, myLib, myEnv, config, secrets, outputs, ... }: {
  imports = [ outputs.homeManagerModules.recentf ];
  config = with myEnv;
    let
      nodes = secrets.nodes;
      toTramps = nodeNames:
        lib.attrsets.genAttrs nodeNames
        (name: (lib.attrsets.getAttr name nodes).ip);
    in lib.mkMerge [{
      programs.recentf = {
        enable = true;
        databaseUrl =
          "postgres://${username}:${secrets.sql.localPassword}@localhost:5432/recentf";
        # tramps = toTramps [ "RaspberryPi" "Vultr" ];
        tramps = lib.attrsets.mapAttrs (node: info:
          if (builtins.hasAttr "publicIp" info) then
            info.publicIp
          else
            info.localIp) secrets.nodes;
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
    }];
}

