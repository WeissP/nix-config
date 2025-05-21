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
    "/mnt/media_hhd_array" = {
      fsType = "fuse.mergerfs";
      device = "/mnt/media/hhd1:/mnt/media/hhd2";
      options = [
        "cache.files=off"
        "category.create=pfrd"
        "func.getattr=newest"
        "dropcacheonclose=false"
      ];
    };
    "/media" = {
      fsType = "fuse.mergerfs";
      device = "/mnt/media/ssd1:/mnt/media/hhd1:/mnt/media/hhd2";
      options = [
        "cache.files=off"
        "category.create=ff"
        "func.getattr=newest"
        "dropcacheonclose=false"
      ];
    };
  };
}
