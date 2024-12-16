{
  pkgs,
  myEnv,
  myLib,
  lib,
  ...
}:
let
  LEDGER_DIR = "${myEnv.financeDir}/journals";
  LEDGER_FILE = "${LEDGER_DIR}/main.journal";
  LEDGER_HELPER_RULE_PATH = "${myEnv.homeDir}/Documents/notes/20240114T174325--hledger-config__hledger.org";
in
{
  home = {
    packages = with pkgs; [
      hledger
      hledger-importer
      hledger-ui
      hledger-web
    ];
    sessionVariables = {
      inherit LEDGER_DIR LEDGER_FILE LEDGER_HELPER_RULE_PATH;
    };
  };

  systemd.user = {
    services = {
      hledger-web = myLib.service.startup {
        inherit (myEnv) username;
        binName = "hledger-web";
        service.Environment = "LEDGER_DIR=${LEDGER_DIR} LEDGER_FILE=${LEDGER_FILE} LEDGER_HELPER_RULE_PATH=${LEDGER_HELPER_RULE_PATH}";
      };
      hledger-importer = {
        Unit.Description = "importing hledger records";
        Service = {
          Environment = "LEDGER_DIR=${LEDGER_DIR} LEDGER_FILE=${LEDGER_FILE} LEDGER_HELPER_RULE_PATH=${LEDGER_HELPER_RULE_PATH} PATH=${pkgs.pass}/bin";
          ExecStart = "${pkgs.hledger-importer}/bin/hledger-importer --download --import -a Paypal -a Hand --import-to-journal";
        };
      };
    };
    timers = {
      hledger-importer = {
        Unit.Description = "importing hledger records every day";
        Timer = {
          OnCalendar = "*-*-* 14:00:00"; # at 14:00 every day
          Persistent = true;
          Unit = "hledger-importer.service";
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };
    };
  };
}
