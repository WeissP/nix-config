{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
    inputs.raspberry-pi-nix.nixosModules.sd-image
  ];

  # bcm2711 for rpi 3, 3+, 4, zero 2 w
  # bcm2712 for rpi 5
  # See the docs at:
  # https://www.raspberrypi.com/documentation/computers/linux_kernel.html#native-build-configuration
  raspberry-pi-nix.board = "bcm2711";
  boot.initrd.systemd.tpm2.enable = false;
  hardware = {
    raspberry-pi = {
      config = {
        all = {
          base-dt-params = {
            BOOT_UART = {
              value = 1;
              enable = true;
            };
            uart_2ndstage = {
              value = 1;
              enable = true;
            };
          };
          dt-overlays = {
            disable-bt = {
              enable = true;
              params = { };
            };
          };
        };
      };
    };
  };
  system.stateVersion = "24.11";
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
