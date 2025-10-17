{
  myEnv,
  lib,
  pkgs,
  secrets,
  ...
}:
with myEnv;
{
  imports = [
    ../common/minimum.nix
    ../common/sing-box.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.docker.enable = true;
  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        KbdInteractiveAuthentication = true;
      };
    };
    xserver = {
      dpi = 120;
    };
  };

  environment = {
    systemPackages = [
      pkgs.wireguard-tools
    ];
  };
  networking = {
    firewall = {
      enable = false;
      checkReversePath = false;
    };
    hostName = "${username}-${configSession}";
  };

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

  system.stateVersion = "25.11";
}
