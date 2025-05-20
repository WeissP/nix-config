{
  lib,
  myEnv,
  mainDevice,
  hhd4t,
  hhd8tArray,
  swapSize ? "32G",
  # Default user and group IDs (1000 is typically the first normal user)
  userId ? 1000,
  groupId ? 1000,
  ...
}:
let
  mainDiskCfg = {
    main = {
      type = "disk";
      # When using disko-install, we will overwrite this value from the commandline
      device = mainDevice;
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
      device = hhd4t;
      content = {
        type = "gpt";
        partitions = {
          backup = {
            size = "100%";
            content = {
              type = "btrfs";
              mountpoint = "/";
              mountOptions = [ "compress=zstd:6" ];
              extraArgs = [ "-f" ]; # Override existing partition
              subvolumes = {
                "/btrbk" = {
                  mountpoint = "/btrbk";
                };
              };
            };
          };
        };
      };
    };
  };

  hhdMediaCfgs = lib.listToAttrs (
    lib.imap0 (idx: devicePath: {
      name = if idx == 0 then "media_parity0" else "media_hhd${toString idx}";
      value = {
        type = "disk";
        device = devicePath;
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = if idx == 0 then "/mnt/media/parity0" else "/mnt/media/hhd${toString idx}";
              };
            };
          };
        };
      };
    }) hhd8tArray
  );

in
{
  disko.devices = {
    disk = mainDiskCfg // backupDiskCfg // hhdMediaCfgs;
  };
}
