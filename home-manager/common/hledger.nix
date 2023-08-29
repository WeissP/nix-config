{ pkgs, myEnv, myLib, lib, ... }:

{
  home = {
    packages = [ pkgs.hledger ];
    sessionVariables = { LEDGER_FILE = "${myEnv.financeDir}/main.journal"; };
  };
}
