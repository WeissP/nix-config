{
  pkgs,
  lib,
  secrets,
  ...
}:
{
  imports = [
    ../common/minimum.nix
    ../common/zsh.nix
    ../common/syncthing.nix
    ../common/sing-box.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services = {
    create_ap = {
      enable = false;
      settings = {
        INTERNET_IFACE = "enp5s0";
        WIFI_IFACE = "wlp4s0";
        SSID = "DBIS-bai-Hotspot";
        PASSPHRASE = "dbis-group-bai";
        SHARE_METHOD = "nat";
      };
    };
    # disable built-in bluetooth adapter
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0032", ATTR{authorized}="0"
    '';
    xserver = {
      dpi = 120;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      wireguard-tools
      linux-wifi-hotspot
    ];
  };
  hardware = {
    bluetooth = {
      enable = true;
    };
  };

  networking = {
    firewall = {
      enable = false;
      checkReversePath = false;
    };
    hostName = "mini";
  };

  virtualisation.docker.enable = true;
  security.sudo.extraRules = [
    {
      users = [ "weiss" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];

  powerManagement.resumeCommands =
    let
      p = lib.getExe pkgs.autorandr;
    in
    "sleep 60s && ${p} off && ${p} --match-edid default";

  system.stateVersion = "25.05";
}
