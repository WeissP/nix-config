{
  inputs,
  outputs,
  myEnv,
  lib,
  config,
  pkgs,
  username,
  secrets,
  myLib,
  ...
}:
{
  environment.variables = {
    MEILI_EXPERIMENTAL_DUMPLESS_UPGRADE = "True";
  };
  services.meilisearch = {
    enable = true;
    # package = pkgs.meilisearch118;

    # listenAddress = secrets.nodes."${myEnv.configSession}".tailscale.ipv4;
    listenAddress = "0.0.0.0";
    # settings = {
    #   db_path = "/var/lib/meilisearch/data.ms";
    #   snapshot_dir = "/var/lib/meilisearch/snapshots";
    # };
  };
}
