{
  pkgs,
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
  programs.steam.protontricks.enable = true;

  services = {
    home-assistant = {
      enable = true;
      extraComponents = [
        "esphome"
        "met"
        "radio_browser"
        "zha"
        "xiaomi"
        "xiaomi_ble"
        "xiaomi_aqara"
        "xiaomi_miio"
      ];
      config = {
        # Includes dependencies for a basic setup
        # https://www.home-assistant.io/integrations/default_config/
        default_config = { };
        "automation ui" = "!include automations.yaml";
      };
    };
    xserver = {
      dpi = 120;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      wireguard-tools
      bluetui
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

  system.stateVersion = "25.05";
}
