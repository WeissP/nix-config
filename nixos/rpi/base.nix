{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.raspberry-pi-nix.nixosModules.raspberry-pi ];
  # bcm2711 for rpi 3, 3+, 4, zero 2 w
  # bcm2712 for rpi 5
  # See the docs at:
  # https://www.raspberrypi.com/documentation/computers/linux_kernel.html#native-build-configuration
  raspberry-pi-nix.board = "bcm2711";
  time.timeZone = "Europe/Berlin";
  users.users.root.initialPassword = "root";
  networking = {
    # hostName = "basic-example";
    useDHCP = false;
    interfaces = {
      wlan0.useDHCP = true;
      eth0.useDHCP = true;
    };
  };
  hardware = {
    bluetooth.enable = true;
    raspberry-pi = {
      config = {
        all = {
          base-dt-params = {
            # enable autoprobing of bluetooth driver
            # https://github.com/raspberrypi/linux/blob/c8c99191e1419062ac8b668956d19e788865912a/arch/arm/boot/dts/overlays/README#L222-L224
            krnbt = {
              enable = true;
              value = "on";
            };
          };
        };
      };
    };
  };
  system = {
    # build.sdImage.compressImage = lib.mkForce false;
    stateVersion = "24.11";
  };
}
# {
#   # This causes an overlay which causes a lot of rebuilding
#   environment.noXlibs = lib.mkForce false;
#   # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix" creates a
#   # disk with this label on first boot. Therefore, we need to keep it. It is the
#   # only information from the installer image that we need to keep persistent
#   fileSystems."/" = {
#     device = "/dev/disk/by-label/NIXOS_SD";
#     fsType = "ext4";
#   };
#   boot = {
#     kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
#     loader = {
#       generic-extlinux-compatible.enable = lib.mkDefault true;
#       grub.enable = lib.mkDefault false;
#     };
#   };
#   nix.settings = {
#     experimental-features = lib.mkDefault "nix-command flakes";
#     trusted-users = [
#       "root"
#       "@wheel"
#     ];
#   };
#   system.stateVersion = "24.11";
# }
