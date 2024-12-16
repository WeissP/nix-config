{
  inputs,
  outputs,
  lib,
  config,
  myEnv,
  pkgs,
  secrets,
  configSession,
  remoteFiles,
  ...
}:
{
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  environment.systemPackages = with pkgs; [ amdgpu_top ];
}
