{
  pkgs,
  myEnv,
  remoteFiles,
  ...
}:
with myEnv;
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
        "category.create=msppfrd"
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

  systemd.services.move-ssd-to-hdd = {
    description = "Move large files from /mnt/media/ssd1 to /mnt/media_hdd_array";
    path = with pkgs; [
      jc
      nushell
      rsync
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false;
    };
    script =
      let
        jcModule = "${remoteFiles.nuScripts}/modules/jc/";
      in
      ''
        nu -c "use ${scriptsDir}/logfile.nu; logfile set-log-file /mnt/media/ssd1/.rsync_ssd_to_hdd.log; logfile set-level info; use ${jcModule}; use ${scriptsDir}/move_ssd_to_hdd.nu; move_ssd_to_hdd"
      '';
    after = [
      "mnt-media-hdd1.mount"
      "mnt-media-hdd2.mount"
      "mnt-media-ssd1.mount"
      "mnt-media_hdd_array.mount"
    ];
    requires = [
      "mnt-media-hdd1.mount"
      "mnt-media-hdd2.mount"
      "mnt-media-ssd1.mount"
      "mnt-media_hdd_array.mount"
    ];
  };
}
