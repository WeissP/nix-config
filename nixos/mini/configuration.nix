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

  services.btrbk.instances =
    let
      preserve_hour_of_day = "4";
      preserve_day_of_week = "sunday";
      snapshot_dir_root = "/btrbk_snapshots";
    in
    {
      important_snapshots = {
        onCalendar = "*:0/15"; # every 15 minutes
        settings = {
          inherit preserve_hour_of_day preserve_day_of_week;
          snapshot_dir = snapshot_dir_root + "/important";
          snapshot_preserve_min = "3h";
          snapshot_preserve = "3h";
          snapshot_create = "onchange";

          subvolume = {
            "/home/weiss/nix-config" = { };
            "/home/weiss/Documents" = { };
            "/home/weiss/projects" = { };
          };
        };
      };
      all_snapshots = {
        onCalendar = "*-*-* 18:00:00"; # every day at 18:00
        settings = {
          inherit preserve_hour_of_day preserve_day_of_week;

          snapshot_dir = snapshot_dir_root + "/all";
          snapshot_preserve_min = "3d";
          snapshot_create = "always";

          subvolume = {
            "/" = { };
            "/home/weiss" = { };
            "/home/weiss/nix-config" = { };
            "/home/weiss/Documents" = { };
            "/home/weiss/projects" = { };
          };
        };
      };
    };

  system.stateVersion = "25.05";
}
