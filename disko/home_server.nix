{
  lib,
  myEnv,
  swapSize ? "32G",
  ...
}:
let
  mainDiskCfg = {
    main = {
      type = "disk";
      device = myEnv.mainDevice;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            name = "ESP";
            start = "1M";
            end = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "1T";
            content = {
              type = "btrfs";
              mountpoint = "/";
              mountOptions = [ "compress=zstd:1" ];
              extraArgs = [ "-f" ]; # Override existing partition
              # Subvolumes must set a mountpoint in order to be mounted,
              # unless their parent is mounted
              subvolumes = {
                # Subvolume name is different from mountpoint
                "/rootfs" = {
                  mountpoint = "/";
                };
                "/btrbk_snapshots" = {
                  mountpoint = "/btrbk_snapshots";
                };
                # Subvolume name is the same as the mountpoint
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd:1" ];
                };
                # Sub(sub)volume doesn't need a mountpoint as its parent is mounted
                "/home/${myEnv.username}" = { };
                # User subvolumes are created manually in the disko-install script
                # Parent is not mounted so the mountpoint must be set
                "/nix" = {
                  mountOptions = [
                    "compress=zstd:1"
                    "noatime"
                  ];
                  mountpoint = "/nix";
                };
                # Subvolume for the swapfile
                "/swap" = {
                  mountpoint = "/.swapvol";
                  swap = {
                    swapfile.size = swapSize;
                  };
                };
              };
            };
          };
          media = {
            name = "media";
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/mnt/media/ssd1";
            };
          };
        };
      };
    };
  };

  backupDiskCfg = {
    backup = {
      type = "disk";
      device = myEnv.hdd4t;
      content = {
        type = "gpt";
        partitions = {
          backup = {
            size = "100%";
            content = {
              type = "btrfs";
              mountpoint = "/btrbk";
              mountOptions = [ "compress=zstd:6" ];
              extraArgs = [ "-f" ]; # Override existing partition
            };
          };
        };
      };
    };
  };

  hddMediaCfgs = lib.listToAttrs (
    lib.imap0 (idx: devicePath: {
      name = "media${toString idx}";
      value = {
        type = "disk";
        device = devicePath;
        content = {
          type = "gpt";
          partitions = {
            media =
              let
                name = if idx == 0 then "parity0" else "hdd${toString idx}";
              in
              {
                inherit name;
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/mnt/media/${name}";
                };
              };
          };
        };
      };
    }) myEnv.hdd8tArray
  );

  hddMediaCfgsNoParity = lib.listToAttrs (
    lib.imap0 (idx: devicePath: {
      name = "media${toString (idx + 1)}";
      value = {
        type = "disk";
        device = devicePath;
        content = {
          type = "gpt";
          partitions = {
            media =
              let
                partitionLabel = "hdd${toString (idx + 1)}";
              in
              {
                name = partitionLabel;
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/mnt/media/${partitionLabel}";
                };
              };
          };
        };
      };
    }) (lib.lists.tail myEnv.hdd8tArray)
  );

in
{
  disko.devices = {
    disk = mainDiskCfg // backupDiskCfg // hddMediaCfgsNoParity;
  };
}
