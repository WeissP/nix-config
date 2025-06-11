{
  pkgs,
  secrets,
  myEnv,
  lib,
  ...
}:
with myEnv;
(ifLinux {
  services.btrbk =
    let
      preserve_hour_of_day = "4";
      preserve_day_of_week = "sunday";
      snapshot_dir_root = "/btrbk_snapshots";
    in
    lib.mkMerge [
      (ifHomeServer {
        instances = {
          snapshots = {
            onCalendar = "*-*-* 20:00:00";
            settings = {
              inherit preserve_hour_of_day preserve_day_of_week;

              snapshot_dir = snapshot_dir_root;
              snapshot_preserve = "5d";
              snapshot_create = "always";

              subvolume = {
                "/" = { };
              };
            };
          };
          backup = {
            onCalendar = "*-*-* 21:00:00";
            settings = {
              inherit preserve_hour_of_day preserve_day_of_week;
              snapshot_dir = snapshot_dir_root;
              snapshot_create = "no";
              target_preserve_min = "no";
              target_preserve = "10d 10w 24m";
              volume."/" = {
                snapshot_dir = snapshot_dir_root;
                subvolume = {
                  "/" = {
                    target = "/btrbk/homeServer";
                  };
                };
              };
            };
          };
        };
      })
      (ifLinuxPersonal {
        instances = {
          important_snapshots = {
            onCalendar = "*:0/15"; # every 15 minutes
            settings = {
              inherit preserve_hour_of_day preserve_day_of_week;
              snapshot_dir = snapshot_dir_root + "/important";
              snapshot_preserve = "10h 3d";
              snapshot_create = "onchange";

              subvolume = {
                "/home/${username}/nix-config" = { };
                "/home/${username}/Documents" = { };
                "/home/${username}/projects" = { };
              };
            };
          };

          all_snapshots = {
            onCalendar = "*-*-* 18:00:00";
            settings = {
              inherit preserve_hour_of_day preserve_day_of_week;

              snapshot_dir = snapshot_dir_root + "/all";
              snapshot_preserve = "3h 3d";
              snapshot_create = "always";

              subvolume = {
                "/" = { };
                "/home/${username}/" = { };
                "/home/${username}/nix-config" = { };
                "/home/${username}/Documents" = { };
                "/home/${username}/projects" = { };
              };
            };
          };
        };
      })
      (ifDesktop {
        instances = {
          remote_backup = {
            onCalendar = "*-*-* 18:30:00";
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
                    "/home/${username}/nix-config" = genTarget "nix-config";
                    "/home/${username}/Documents" = genTarget "Documents";
                    "/home/${username}/projects" = genTarget "projects";
                  };
                };
            };
          };
        };
      })
    ];
})
