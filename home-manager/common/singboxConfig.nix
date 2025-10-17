{
  pkgs,
  myEnv,
  myLib,
  lib,
  secrets,
  config,
  ...
}:
{
  home.file = builtins.listToAttrs (
    lib.mapAttrsToList (cfgName: cfg: {
      name = "${myEnv.singboxCfgDir}/1.12/${cfgName}.json";
      value.text = builtins.toJSON cfg;
    }) secrets.singbox.config
  );
}
