{ config, lib, pkgs, ... }:

{
  services = {
    postgresql = {
      enable = true;
      package = pkgs.lts.postgresql_15;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE weiss CREATEDB;
        CREATE DATABASE weiss;
        GRANT ALL PRIVILEGES ON DATABASE weiss TO weiss;
        ALTER ROLE "weiss" WITH LOGIN;
      '';
    };
    postgresqlBackup.enable = true;
  };

}

