{ inputs, outputs, myEnv, lib, myLib, config, pkgs, ... }:
with myEnv; {
  imports = if usage == "personal" then
    [ ../common/personal.nix ]
  else if usage == "server" then [
    ../common/minimum.nix
    ../common/webman.nix
    ../common/shell.nix
  ] else
    [ ../common/minimum.nix ];

  config = (ifServer {
    systemd.user.services."ensure-webman-db" = myEnv.ensurePsqlDb "webman";
    home = {
      sessionVariables = { SCRIPTS_DIR = myEnv.scriptsDir; };
      file = {
        "${homeDir}/scripts/ensure_psql_db.sh" = {
          source = ../common/config_files/scripts/ensure_psql_db.sh;
        };
      };
    };
  });
}
