{
  pkgs,
  lib,
  myLib,
  myEnv,
  config,
  secrets,
  outputs,
  ...
}:

{
  imports = [ outputs.homeManagerModules.recentf ];
  config =
    with myEnv;
    let
      nodes = secrets.nodes;
      toTramps = nodeNames: lib.attrsets.genAttrs nodeNames (name: (lib.attrsets.getAttr name nodes).ip);
    in
    lib.mkMerge [
      {
        programs.recentf = {
          enable = true;
          databaseUrl = "postgres://${username}:${secrets.sql.localPassword}@localhost:5432/recentf";
          # tramps = toTramps [ "RaspberryPi" "Vultr" ];
          tramps = lib.attrsets.mapAttrs (
            node: info: if (builtins.hasAttr "publicIp" info) then info.publicIp else info.localIp
          ) secrets.nodes;
          cleanFreq = "1h";
          filters = [
            { name_prefix = "COMMIT_EDITMSG"; }
            {
              name_regex = ''^\d{8}T\d{6}.*--.+\..+$'';
            }
            {
              dir_prefix = "/dev/shm";
            }
            {
              dir_prefix = "${homeDir}/nix-config/home-manager/common/emacs/configs";
              ext = "el";
            }
            {
              dir_prefix = "${homeDir}/.password-store";
              ext = "gpg";
            }
          ];
        };
      }
    ];
}
