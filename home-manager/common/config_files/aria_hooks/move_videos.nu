# Script to move video files and trash remaining items.
#
# This script is intended to be used as a hook, for example, with aria2.
# It moves video files from a source directory to a target directory using rsync,
# and then trashes any remaining files and directories in the source directory using gtrash.

export def move_videos [source_dir: string, target_dir: string] {
    # Ensure source_dir exists
    if not ($source_dir | path exists) {
        logfile error $"Source directory '($source_dir)' does not exist."
        return
    }

    # Ensure target_dir exists, create if not
    if not ($target_dir | path exists) {
        logfile debug $"Target directory '($target_dir)' does not exist. Creating it."
        mkdir $target_dir
    }

    logfile info $"Processing download from '($source_dir)' to '($target_dir)'"

    let videos = if ($source_dir | path type) == "file" {
      [$source_dir]
    } else {
      ls -f ...(glob $"($source_dir)/**/*.{3gp,avi,f4v,flv,m2ts,m4v,mkv,mov,mp4,mpeg,rm,rmvb,ts,vob,webm,wmv,strm,mpg}") | where size > 200Mb | get name
    }

    if ($videos | is-empty) {
        logfile debug "No video files were found to move. No items will be trashed."
    } else {
        logfile info $"moving videos: ($videos)"
        $videos | each { |video_file|
           logfile debug $"moving video: ($video_file)"        
           rsync -a --backup --suffix=_rsync_backup --remove-source-files $video_file $target_dir
           logfile debug $"video ($video_file) moved"        
        }
        logfile info $"All Videos moved"
        if (($source_dir | path exists) and ($source_dir != $env.COMPLETE)) {
           logfile info $"Trashing remaining items from '($source_dir)' using gtrash..."
           gtrash put --home-fallback $source_dir        
           logfile info $"all files trashed"
        } 
    }
}
