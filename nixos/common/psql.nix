{ pkgs, lib, myEnv, config, inputs, secrets, outputs, ... }:
with lib;
with myEnv;
let cfg = config.services.myPostgresql;
in {
  options.services.myPostgresql = rec {
    enable = mkEnableOption "myPostgresql";
    package = mkOption {
      type = types.package;
      example = literalExpression "pkgs.postgresql_11";
      description = ''
        PostgreSQL package to use.
      '';
    };
    dataDir = with types;
      mkOption {
        type = str;
        default = "/var/lib/postgresql";
      };
    databases = with types;
      mkOption {
        type = listOf str;
        default = [ ];
      };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services = mkMerge [
        {
          postgresql = mkMerge [
            {
              enable = true;
              package = cfg.package;
              enableTCPIP = true;
              authentication = pkgs.lib.mkOverride 10 ''
                local all all              trust
                host  all all 127.0.0.1/32 trust
                host  all all ::1/128      md5
              '';
            }
            (ifDarwin {
              dataDir = cfg.dataDir;
              initdbArgs = [ "--locale=de_DE.UTF-8" "-D ${cfg.dataDir}" ];
            })
            (ifLinux {
              initialScript = pkgs.writeText "backend-initScript" ''
                CREATE ROLE ${username} WITH LOGIN PASSWORD '${secrets.sql.localPassword}' CREATEDB;
                CREATE DATABASE ${username};
                GRANT ALL PRIVILEGES ON DATABASE ${username} TO ${username};
                ALTER ROLE ${username} WITH LOGIN;
              '';
            })
          ];
        }
        (ifLinux { postgresqlBackup.enable = false; })
      ];
    }
    (ifDarwin {
      launchd.user.agents.postgresql.serviceConfig = {
        StandardErrorPath =
          "${homeDir}/.local/share/postgresql/postgres.error.log";
        StandardOutPath = "${homeDir}/.local/share/postgresql/postgres.out.log";
      };

      system.activationScripts.preActivation = {
        enable = true;
        text = ''
          if [ ! -f "${cfg.dataDir}/PG_VERSION" ]; then
            echo "PG_VERSION does not exist, removing ${cfg.dataDir}..."
            rm -rf "${cfg.dataDir}"
          fi

          if [ ! -d "${cfg.dataDir}" ]; then
            echo "creating PostgreSQL data directory..."
            sudo mkdir -m 0750 -p ${cfg.dataDir}
            chown -R ${username}:staff ${cfg.dataDir}
          fi
        '';
      };
    })
  ]);
}

