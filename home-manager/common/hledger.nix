{ pkgs, myEnv, myLib, lib, ... }:

{
  home = {
    packages = [ pkgs.hledger ];
    sessionVariables = {
      LEDGER_FILE = "${myEnv.financeDir}/main.journal";
      LEDGER_DIR = "${myEnv.financeDir}";
      LEDGER_CONFIG =
        "/home/weiss/Documents/Org-roam/ƦProject-ledger_config_2022101011.org";
    };
  };
}
