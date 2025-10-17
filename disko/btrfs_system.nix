{
  myEnv,
  swapSize ? "64G",
  # Default user and group IDs (1000 is typically the first normal user)
  userId ? 1000,
  groupId ? 1000,
  ...
}:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # When using disko-install, we will overwrite this value from the commandline
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
              size = "100%";
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
          };
        };
      };
    };
  };
}
