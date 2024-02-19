{ inputs, outputs, lib, config, myEnv, pkgs, secrets, configSession, ... }:
with myEnv; {
  imports = [ ../common/personal.nix outputs.nixosModules.v2ray ];
  time.timeZone = "Europe/Berlin";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        KbdInteractiveAuthentication = true;
      };
    };
    myPostgresql.databases = [ "webman" "recentf" "digivine" ];
  };

  environment = { systemPackages = [ pkgs.wireguard-tools ]; };
  networking = {
    firewall = {
      enable = false;
      checkReversePath = false;
    };
    hostName = "${username}-${configSession}";
  };

  virtualisation.docker.enable = true;
  security.sudo.extraRules = [
    # Allow execution of any command by all users in group sudo,
    # requiring a password.
    # {
    #   groups = [ "sudo" ];
    #   commands = [ "ALL" ];
    # }
    {
      users = [ "weiss" ];
      commands = [{
        command = "ALL";
        options =
          [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
      }];
    }
  ];

  services.weissV2ray = {
    enable = false;
    configFile = "/home/weiss/nix-config/nixos/desktop/v2ray.json";
  };

  services.btrbk.instances = let
    preserve_hour_of_day = "4";
    preserve_day_of_week = "sunday";
    snapshot_dir_root = "/btrbk_snapshots";
  in {
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
    all_snampshots = {
      onCalendar = "*-*-* 18:00:00"; # every day at 18:00
      settings = {
        inherit preserve_hour_of_day preserve_day_of_week;

        snapshot_dir = snapshot_dir_root + "/all";
        snapshot_preserve_min = "3d";
        snapshot_create = "always";

        subvolume = {
          "/" = { };
          "/home" = { };
          "/home/weiss/nix-config" = { };
          "/home/weiss/Documents" = { };
          "/home/weiss/projects" = { };
        };
      };
    };
    local_backup = {
      onCalendar = "*-*-* 18:30:00"; # every day at 18:30
      settings = {
        inherit preserve_hour_of_day preserve_day_of_week;

        snapshot_dir = snapshot_dir_root + "/all";
        snapshot_create = "no";

        target = "/mnt/backup/btrbk";
        target_preserve_min = "no";
        target_preserve = "20d";
        subvolume = {
          "/home/weiss/nix-config" = { };
          "/home/weiss/Documents" = { };
          "/home/weiss/projects" = { };
        };
      };
    };
    external_backup = {
      onCalendar = "*-*-* 18:30:00"; # every day at 18:30
      settings = {
        inherit preserve_hour_of_day preserve_day_of_week;

        snapshot_dir = snapshot_dir_root + "/all";
        snapshot_create = "no";

        target = "/run/media/weiss/Seagate_Backup/btrbk";
        target_preserve_min = "no";
        target_preserve = "10d 10w *m";
        subvolume = {
          "/" = { };
          "/home" = { };
          "/home/weiss/nix-config" = { };
          "/home/weiss/Documents" = { };
          "/home/weiss/projects" = { };
        };
      };
    };
  };

  system.stateVersion = "23.05";
}
