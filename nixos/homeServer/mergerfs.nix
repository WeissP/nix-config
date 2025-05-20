{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    mergerfs
  ];
  fileSystems."/storage" = {
    fsType = "fuse.mergerfs";
    device = "ssd:hhd:hhd";
    options = [
      "category.create=ff"
      "minfreespace=100G"
    ];
  };
}
