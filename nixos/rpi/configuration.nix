{
  modulesPath,
  inputs,
  outputs,
  lib,
  config,
  myEnv,
  pkgs,
  secrets,
  configSession,
  ...
}:
with myEnv;
{
  imports = [
    ../common/minimum.nix
    ../common/psql.nix
    ../common/zsh.nix
  ];
  time.timeZone = "Europe/Berlin";
  environment.systemPackages = with pkgs; [
    vim
    git
  ];
  services = {
    openssh.enable = true;
    myPostgresql = {
      enable = true;
      package = pkgs.lts.postgresql_15;
    };
  };
  networking.hostName = "rpi";
}
