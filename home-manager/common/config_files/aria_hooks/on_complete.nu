# This script is triggered by Aria2's on-download-complete hook.
# It first moves downloaded files/directories to $env.COMPLETE.
# Then, if any video files are present, it moves them to $env.VIDEO_TARGET_DIR.
# For some reason, "I/O ERROR" always occur when this is invoked by aria, however, all jobs are still performed as needed, so such erros are ignored for now. 

# Required environment variables:
# - DOWNLOAD:          Directory where Aria2 downloads files.
# - COMPLETE:          Directory where completed downloads are initially moved.
# - LOG_FILE:          Path to the rsync log file.
# - NU_LOG_FILE: Path to the script's own log file.
# - VIDEO_TARGET_DIR:  Directory where video files are finally moved.

const video_ext = [3gp,avi,f4v,flv,m2ts,m4v,mkv,mov,mp4,mpeg,rm,rmvb,ts,vob,webm,wmv,strm,mpg]
const min_video_move_size = 200Mb

# Sets predefined environment variables for debugging purposes.
# Activates debug level logging.
export def --env set-debug-env [] {
     $env.DOWNLOAD = "/home/weiss/Downloads"
     $env.COMPLETE = "/home/weiss/Downloads/completed/"
     $env.VIDEO_TARGET_DIR = "/home/weiss/Downloads/completed-videos/"
     $env.LOG_FILE = "/home/weiss/Downloads/x.log"
     $env.NU_LOG_FILE = "/home/weiss/Downloads/x.log"
     logfile set-level debug
}

# Entry point for the Aria2 on-download-complete hook.
# Moves the downloaded file/directory to $env.COMPLETE.
# Then, calls move_videos to further process video files.
export def main [task_id: string, num_files: int, source_file?: string] {
   logfile set-level $"($env.log_level)"
   logfile debug $"Script invoked by task_id: ($task_id), num_files: ($num_files), source_file: ($source_file)" 
   if ($num_files <= 0 or ($source_file | is-empty) or not ($source_file | path exists) or not ($source_file | str starts-with $env.DOWNLOAD)) { return }
   let handled = handle_input_file $source_file
   logfile debug $"Regarding input ($source_file), sync ($handled.source) to ($handled.dest)" 
   try {   
      notify downloads $"Download Finished: ($handled.source)" --title Aria2 -p 1 
   } catch { |err| 
      if ($err.msg != "I/O error") {
        logfile error $"unable to send notification: ($err.msg)."    
        return $err.rendered      
      }
   }
   mkdir $env.COMPLETE
   try {
      rsync -aq --backup --suffix=_rsync_backup --remove-source-files --log-file=$"($env.LOG_FILE)" $handled.source $handled.dest
   } catch { |err| 
      if ($err.msg != "I/O error") {
        logfile error $"Failed to sync ($handled.source) to ($handled.dest): ($err.msg)."    
        return $err.rendered      
      }
   }

   trash $handled.source

   move_videos $handled.expect_dest_path  
}

def trash [p: string] {
   if ($p | path exists) {
      try {
       logfile info $"Trashing remaining items from '($p)' using gtrash..."
       gtrash put --home-fallback $p        
       logfile info $"all files trashed"
      } catch { |err|
         if ($err.msg != "I/O error") {
           logfile error $"Failed to delete ($p): ($err.msg)."    
           error make $err
         }
      }
   }
}

# Generates a unique filename by appending a counter (e.g., file_1.txt)
# if the given filepath already exists in the target directory.
def find_unique_name [filepath: string]  {
    let original_basename = ($filepath | path basename)
    let dir = ($filepath | path dirname)
    let parsed = ($original_basename | path parse)
    let stem = $parsed.stem
    let ext = $parsed.extension

    logfile debug $"Finding unique name for ($filepath)"

    mut new_basename = $original_basename
    mut count = 0

    while (($dir | path join $new_basename) | path exists) {
        $count += 1
        if ($ext | is-empty) {
            $new_basename = $"($stem)_($count)"
        } else {
            $new_basename = $"($stem)_($count).($ext)"
        }
    }

    let unique_path = ($dir | path join $new_basename)
    logfile debug $"Unique name found: ($unique_path)"
    return $unique_path
}

# Determines the source path (original download) and destination path (within $env.COMPLETE).
# Handles both single file downloads and downloads within a directory structure.
# Returns a record with {source, dest, expect_dest_path}.
export def handle_input_file [input_file: string] {
    let split_input = $input_file | path split
    let download_dir_len = $env.DOWNLOAD | path split | length
    if (($split_input | length) <= $download_dir_len + 1) {
      logfile debug $"Detected single file ($input_file)"
      let ori_dest =  [$env.COMPLETE, ($input_file | path basename)] | path join
      let dest = find_unique_name $ori_dest
      { source: $input_file, dest: $dest, expect_dest_path: $dest}
    } else {
      logfile debug $"Detected a file ($input_file) is in a directory"
      let base = $split_input | get $download_dir_len
      { source: ([$env.DOWNLOAD, $base] | path join)
        dest: $env.COMPLETE
        expect_dest_path: ([$env.COMPLETE, $base] | path join)
       }
    }
}

# Scans the source_path (typically a file/directory in $env.COMPLETE) for video files.
# Moves qualifying video files (matching $video_ext and size > $min_video_move_size)
# to $env.VIDEO_TARGET_DIR. If videos are moved from a subdirectory within $env.COMPLETE,
# the remaining contents of that subdirectory are trashed.
export def move_videos [source_path: string] {
    if not ($source_path | path exists) {
        logfile error $"Source path '($source_path)' does not exist."
        return
    }

    let videos = if ($source_path | path type) == "file" {
      if ((($source_path | path parse).extension in $video_ext) and ((du $source_path | first).apparent > $min_video_move_size)) {
      [$source_path]      
      } else {
      []
      }
    } else {
      cd $source_path
      ls -f **/*
        | where size > $min_video_move_size
        | get name
        | where {|f| ($f | path parse).extension in $video_ext}
    }

    cd
    if ($videos | is-empty) {
        logfile debug "No video files were found to move. No items will be trashed."
    } else {
        logfile info $"Processing download from '($source_path)' to '($env.VIDEO_TARGET_DIR)'"
        logfile info $"moving videos: ($videos)"
        $videos | each { |video_file|
           let dir = [$env.VIDEO_TARGET_DIR, ($video_file | path parse).stem] | path join
           mkdir $dir 
           logfile debug $"moving video ($video_file) to ($dir)"        
           try {
             rsync -aq --backup --suffix=_rsync_backup --remove-source-files --log-file=$"($env.LOG_FILE)" $video_file $dir
           } catch { |err| 
             if ($err.msg != "I/O error") {
               logfile error $"Failed to move videos: ($err.msg)."    
               return $err.rendered      
             }
           }
           logfile debug $"video ($video_file) moved"        
        }
        logfile info $"All Videos moved"
        trash $source_path 
    }
}
