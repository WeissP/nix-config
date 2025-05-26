{ lib, ... }:

let
  hddMediaParityArray = [
    "/dev/disk/by-id/ata-ST8000VN004-3CP101_WP01VWR3"
  ];

in
{
  disko.devices = {
    disk = lib.listToAttrs (
      lib.imap0 (idx: devicePath: {
        name = "parity${toString (idx + 1)}";
        value = {
          type = "disk";
          device = devicePath;
          content = {
            type = "gpt";
            partitions = {
              data_partition =
                let
                  partitionNameOnDisk = "parity${toString (idx + 1)}";
                in
                {
                  name = partitionNameOnDisk;
                  size = "100%";
                  content = {
                    type = "filesystem";
                    format = "xfs";
                    mountpoint = "/mnt/media/${partitionNameOnDisk}";
                  };
                };
            };
          };
        };
      }) hddMediaParityArray
    );
  };
}
