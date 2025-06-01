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
    # ../common/jellyfin.nix
    ../common/navidrome.nix
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
            snapshot_preserve = "10h 3d";
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
            snapshot_preserve = "3h 3d";
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

        remote_backup = {
          onCalendar = "*-*-* 18:30:00"; # every day at 18:30
          settings = {
            ssh_identity =
              let
                p = pkgs.writeText "key" secrets.ssh."btrbk".private;
              in
              "${p}";

            inherit preserve_hour_of_day preserve_day_of_week;
            snapshot_dir = snapshot_dir_root + "/all";
            snapshot_create = "no";
            target_preserve_min = "no";
            target_preserve = "10d 10w 24m";
            volume."/" =
              let
                genTarget = dir: {
                  target."ssh://${secrets.nodes.homeServer.localIp}/btrbk/desktop/${dir}".ssh_user = "btrbk";
                };
              in
              {
                snapshot_dir = snapshot_dir_root + "/all";

                subvolume = {
                  "/" = genTarget "root";
                  "/home" = genTarget "home";
                  "/home/weiss/nix-config" = genTarget "nix-config";
                  "/home/weiss/Documents" = genTarget "Documents";
                  "/home/weiss/projects" = genTarget "projects";
                };
              };
          };
        };
      };
  };

  system.stateVersion = "25.05";
}
