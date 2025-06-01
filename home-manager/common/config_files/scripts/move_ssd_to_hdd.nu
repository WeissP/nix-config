const MIN_AVAILABLE_SPACE = 50Gb

export def main [] {
    logfile info "Starting rsync to move large files from SSD to HDD array..."
    let available = jc df -B KB | where "mounted_on" == "/mnt/media/ssd1" | get available | first | into filesize 
    if ($available >= $MIN_AVAILABLE_SPACE) {
        logfile debug $"Available space on SSD ($available) is sufficient. No rsync needed at this time."
        return 
    }

    logfile info $"Available space on SSD ($available) is less than ($MIN_AVAILABLE_SPACE). Starting rsync."
    ntfy publish homeServer "Start transferring server files to HDD array"
    rsync -aqhHAXWSx --preallocate --checksum --log-file=/mnt/media/ssd1/.rsync_ssd_to_hdd.log "/mnt/media/ssd1/videos/porn/#processed" "/mnt/media_hdd_array/videos/porn/#processed"
    ls 
    rsync -aqhHAXWSx --preallocate --checksum --remove-source-files --exclude='.*' --exclude='lost+found' --exclude "/mnt/media/ssd1/videos/porn/#processed" --log-file=/mnt/media/ssd1/.rsync_ssd_to_hdd.log /mnt/media/ssd1/ /mnt/media_hdd_array/
    logfile info "Rsync process completed."
}


