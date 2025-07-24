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
    # ../common/navidrome.nix
    ../common/karakeep.nix
    ../common/notesServer.nix
    # ../common/anki-sync-server.nix # unable to use it on IOS without purchasing the APP
    # ./mergerfs.nix
    # ./snapraid.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  programs.steam.protontricks.enable = true;

  services = {
    home-assistant = {
      enable = false;
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
      fd
      bluetui
    ];
  };
  hardware = {
    bluetooth = {
      enable = true;
    };
  };

  networking = {
    interfaces.enp3s0.wakeOnLan = {
      enable = true;
      policy = [
        "magic"
      ];
    };
    firewall = {
      enable = false;
      checkReversePath = false;
    };
  };

  virtualisation = {
    docker.enable = true;

    oci-containers = {
      backend = "docker";
      containers = {
        bgutil-provider = {
          image = "brainicism/bgutil-ytdlp-pot-provider";
          ports = [ "4416:4416" ];
          extraOptions = [ "--init" ];
        };
      };
    };

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

  services.btrbk = {
    sshAccess = [
      {
        key = secrets.ssh."btrbk".public;
        roles = [
          "source"
          "snapshot"
          "send"
          "receive"
          "delete"
          "info"
        ];
      }
    ];
  };

  system.stateVersion = "25.05";
}
