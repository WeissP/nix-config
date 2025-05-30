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
    ../common/gpu.nix
    ../common/jellyfin.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.steam.protontricks.enable = true;

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

  services.btrbk = {
    sshAccess = [
      {
        key = secrets.ssh."163".public;
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

    instances =
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
            snapshot_preserve = "10h 6d 1w";
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
            snapshot_preserve = "3h 3d 1w";
            snapshot_create = "always";

            subvolume = {
              "/" = { };
              "/home/weiss/" = { };
              "/home/weiss/nix-config" = { };
              "/home/weiss/Documents" = { };
              "/home/weiss/projects" = { };
            };
          };
        };
        # local_backup = {
        #   onCalendar = "*-*-* 18:30:00"; # every day at 18:30
        #   settings = {
        #     inherit preserve_hour_of_day preserve_day_of_week;

        #     snapshot_dir = snapshot_dir_root + "/all";
        #     snapshot_create = "no";

        #     target = "/mnt/backup/btrbk";
        #     target_preserve_min = "no";
        #     target_preserve = "20d";
        #     subvolume = {
        #       "/" = { };
        #       "/home" = { };
        #       "/home/weiss/nix-config" = { };
        #       "/home/weiss/Documents" = { };
        #       "/home/weiss/projects" = { };
        #     };
        #   };
        # };
        # remote_backup = {
        #   onCalendar = "*-*-* 18:30:00"; # every day at 18:30
        #   settings = {
        #     ssh_identity = "/home/${username}/.ssh/id_rsa";
        #     target."ssh://${secrets.nodes.homeServer.localIp}/btrbk/desktop".ssh_user = username;

        #     inherit preserve_hour_of_day preserve_day_of_week;

        #     snapshot_dir = snapshot_dir_root + "/all";
        #     snapshot_create = "no";

        #     target_preserve_min = "no";
        #     target_preserve = "10d 10w *m";
        #     subvolume = {
        #       "/" = { };
        #       "/home" = { };
        #       "/home/weiss/nix-config" = { };
        #       "/home/weiss/Documents" = { };
        #       "/home/weiss/projects" = { };
        #     };
        #   };
        # };
      };
  };

  system.stateVersion = "25.05";
}
