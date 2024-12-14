{
  modulesPath,
  inputs,
  outputs,
  lib,
  config,
  myEnv,
  pkgs,
  secrets,
  configSession,
  ...
}:
with myEnv;
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ../common/minimum.nix
    ../common/zsh.nix
  ];

  nix.gc = {
    options = lib.mkForce "--delete-older-than 1d";
  };

  time.timeZone = "Japan";
  # time.timeZone = secrets.v2ray.vmessLinks."/vmess_links_subscription/1";
  networking.hostName = "${username}-${configSession}";

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services = {
    getty.autologinUser = "${username}";
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = true;
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
    ];
  };

  system.stateVersion = "23.11";
}
