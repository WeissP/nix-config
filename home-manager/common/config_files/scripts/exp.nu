#
# Moves large media files from SSD to HDD when free space on the SSD falls below the configured threshold.
# Performs SnapRAID touch and sync, duplicates NFO files then move all other files via rsync, cleans up sources, and sends notifications.
#
# Required environment variables:
#   MIN_AVAILABLE_SPACE_STR  - threshold for SSD free space (e.g., "50Gb")
#   SSD_MOUNT_POINT          - SSD mount point (e.g., "/mnt/media/ssd1")
#   HDD_MOUNT_POINT          - HDD mount point (e.g., "/mnt/media_hdd_array")
#   NFO_DIR                  - directory for NFO files on both disks (e.g., "videos")
#   LOG_DIR                  - path to log dir
#   log_level                - log level for logging (e.g., "debug")
#
export def main [] {
   # logfile set-log-dir-with-timestamped-log $"($env.LOG_DIR)"
   # logfile set-level $"($env.log_level)"
   # let log_file = logfile get_log_file

$env.HDD_MOUNT_POINT = "/mnt/media_hdd_array"
$env.LOG_DIR = "/mnt/media/ssd1/.rsync_ssd_to_hdd_logs"
$env.MIN_AVAILABLE_SPACE_STR = "50Gb"
$env.NFO_DIR = "videos"
$env.Path = [/nix/store/sb4ml8qjxcr2idzdgjcw2bz11p6nzff4-rsync-3.4.1/bin,/nix/store/ix3dyrp4afb1pm52a1n0dzfvb1wpjk30-snapraid-12.4/bin,/nix/store/jghj8vlgsvz73dyz8yabny7f7kk13p79-python3.12-jc-1.25.5/bin,/nix/store/8kapw327n9xwbwzcbd72jmgn1ghfaxny-notify/bin,/nix/store/87fck6hm17chxjq7badb11mq036zbyv9-coreutils-9.7/bin]
$env.SSD_MOUNT_POINT = "/mnt/media/ssd1"
$env.log_level = "debug"




    let MIN_AVAILABLE_SPACE = $env.MIN_AVAILABLE_SPACE_STR | into filesize
    let SSD_NFO_DIR = [$env.SSD_MOUNT_POINT, $env.NFO_DIR] | path join
    let HDD_NFO_DIR = [$env.HDD_MOUNT_POINT, $env.NFO_DIR] | path join

    print $"SSD_NFO_DIR: ($SSD_NFO_DIR)"
    print $"HDD_NFO_DIR: ($HDD_NFO_DIR)"

    # let available = jc df -B KB | where "mounted_on" == $env.SSD_MOUNT_POINT | get available | first | into filesize
    # if ($available >= $MIN_AVAILABLE_SPACE) {
    #     logfile debug $"Available space on SSD ($available) is sufficient. No rsync needed at this time."
    #     return
    # }

    # logfile info $"Available space on SSD ($available) is less than ($MIN_AVAILABLE_SPACE)."

    # logfile debug $"Initiating pre-transfer SnapRAID touch and sync to ensure parity before moving files."
    # snapraid touch
    # snapraid sync

    # notify home-server-maintenance $"Available space on SSD ($available) is less than ($MIN_AVAILABLE_SPACE), rsync files to HDD array..." -p 3

    # logfile debug $"rsync: copying NFO files from ($SSD_NFO_DIR) to ($HDD_NFO_DIR)."

    # rsync -aHAXWS --preallocate --checksum $SSD_NFO_DIR $HDD_NFO_DIR --dry-run

    # ls -f ...(glob ([$SSD_NFO_DIR, "**", "*"] | path join))
    # | where { $in.type == file and ($in.name | path parse).extension != "nfo" }
    # | get name | uniq | each { rm $in }

    # logfile debug $"rsync: copying all non-NFO files from ($SSD_NFO_DIR) to ($HDD_NFO_DIR)."
    # rsync -aqHAXWS --preallocate --checksum --remove-source-files --exclude='.*' --exclude='lost+found' --exclude=$"($SSD_NFO_DIR)" --log-file=$"($log_file)" $env.SSD_MOUNT_POINT $env.HDD_MOUNT_POINT
    # logfile info "Rsync process completed."

    # logfile debug $"All files transferred to HDD. Performing final SnapRAID touch and sync."
    # snapraid touch
    # snapraid sync

    # notify home-server-maintenance $"Successfully moved all files from SSD to HDD array and cleaned up source files." -p 3
}

