{
  config,
  remoteFiles,
  lib,
  pkgs,
  myLib,
  myEnv,
  ...
}:
let
  getSortedAttrNames = attrSet: lib.lists.sortOn lib.id (lib.attrNames attrSet);
in
{
  services.snapraid = {
    enable = true;

    dataDisks = lib.listToAttrs (
      lib.imap1 (index: originalDiskName: {
        name = "d${toString index}";
        value = "/mnt/media/${originalDiskName}";
      }) (getSortedAttrNames myEnv.hddMediaArray)
    );

    parityFiles = lib.imap1 (
      index: diskKey:
      let
        parityFileName = if index == 1 then "snapraid.parity" else "snapraid.${toString index}-parity";
      in
      "/mnt/media/${diskKey}/${parityFileName}"
    ) (getSortedAttrNames myEnv.hddMediaParityArray);

    contentFiles =
      [
        "/var/snapraid.content"
      ]
      ++ (lib.mapAttrsToList (
        diskName: _: "/mnt/media/${diskName}/snapraid.content"
      ) myEnv.hddMediaArray);

    exclude = [
      "*.bak"
      "*.tmp"
      "~*"
      "lost+found/"
      "/lost+found/"
      "System Volume Information/"
      "$RECYCLE.BIN/"
      ".DS_Store"
      "Thumbs.db"
      "*.unrecoverable"
    ];

    extraConfig = ''
      autosave 500
    '';
  };

  systemd.services =
    let
      inherit (myLib) quote;
      inherit (myEnv) scriptsDir;
      inherit (remoteFiles) nuScripts;
      minAvailableSpaceGb = "50Gb";
      ssdMountPoint = "/mnt/media/ssd1";
      hddMountPoint = "/mnt/media_hdd_array";
      nfoDir = "videos";
      logDir = "${ssdMountPoint}/.rsync_ssd_to_hdd_logs";
      moveSsdToHdd = pkgs.additions.writeNuBinWithConfig "move_ssd_to_hdd" {
        modules = [
          "${scriptsDir}/logfile.nu"
          "${nuScripts}/modules/jc/"
        ];
        env = {
          log_level = quote "debug";
          MIN_AVAILABLE_SPACE_STR = quote minAvailableSpaceGb;
          SSD_MOUNT_POINT = quote ssdMountPoint;
          HDD_MOUNT_POINT = quote hddMountPoint;
          NFO_DIR = quote nfoDir;
          LOG_DIR = quote logDir;
          Path =
            with pkgs;
            myLib.mkNuBinPath [
              rsync
              snapraid
              jc
              additions.notify
              coreutils
            ];
        };
      } (builtins.readFile ./move_ssd_to_hdd.nu);
      moveSsdToHddPath = lib.getExe moveSsdToHdd;
    in
    {
      moveSsdToHdd = {
        description = "Move large files from SSD to HDD";
        wants = [ "network.target" ];
        after = [ "network.target" ];
        onFailure = [ "moveSsdToHddFailure.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${moveSsdToHddPath}";
        };
      };

      moveSsdToHddFailure = {
        description = "Failure handler for moveSsdToHdd";
        wants = [ "network.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${lib.getExe pkgs.additions.notify} home-server-maintenance 'Service moveSsdToHdd failed' -p 4";
        };
      };
    };
  systemd.timers.moveSsdToHdd = {
    description = "Daily timer for moveSsdToHdd.service";
    timerConfig = {
      OnCalendar = "*-*-* 12:00:00";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };
}
