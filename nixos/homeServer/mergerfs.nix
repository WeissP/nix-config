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
  fileSystems = {
    "/mnt/media_hdd_array" = {
      fsType = "fuse.mergerfs";
      device = "/mnt/media/hdd1:/mnt/media/hdd2";
      options = [
        "cache.files=off"
        "category.create=pfrd"
        "func.getattr=newest"
        "dropcacheonclose=false"
      ];
    };
    "/media" = {
      fsType = "fuse.mergerfs";
      device = "/mnt/media/ssd1:/mnt/media/hdd1:/mnt/media/hdd2";
      options = [
        "cache.files=off"
        "category.create=ff"
        "func.getattr=newest"
        "dropcacheonclose=false"
      ];
    };
  };
}
