# Merges multiple video files into a single output file using ffmpeg.

export def get_interactive_video_order [videos: list<string> = ["b", "c", "a"]] {
     mut ordered_selection = []
     mut available_videos =  $videos | sort

    print "Starting interactive video ordering..."
 
    while ($available_videos | length) > 1 {
        print "\nAvailable videos to choose from:"
        print $available_videos

        let max_idx = ($available_videos | length) - 1
        let user_choice_str = input $"Select the Next video by number 0-($max_idx) \(or press Enter to add all remaining): " | str trim
        
        if ($user_choice_str | is-empty) {
            print "\nInput is empty. Appending remaining videos in their current order."
            break
        }
        
        let chosen_idx = $user_choice_str | into int
        
        let selected_video = ($available_videos | get $chosen_idx)
        $ordered_selection = ($ordered_selection | append $selected_video)
        $available_videos = ($available_videos | drop nth $chosen_idx)
        print $"Selected: ($selected_video | path basename)"
    }

    print "\nVideo ordering complete."
    return ($ordered_selection ++ $available_videos)
}

export def main [
    ...video_paths: path
    --output(-o): path = "merged_output.mp4"
] {
    if ($video_paths | is-empty) {
        error make { msg: "No video files provided. Usage: merge_videos <file1> <file2> ... [--output <output_file>]" }
        exit 1
    }

    for vid_path in $video_paths {
        if not ($vid_path | path exists) {
            error make { msg: $"Video file not found: ($vid_path)" }
            exit 1
        }
        if ($vid_path | path type) == "dir" {
            error make { msg: $"Input path is a directory, not a file: ($vid_path)"}
            exit 1
        }
    }

    let sorted_video_paths = get_interactive_video_order $video_paths

    let temp_file_name = mktemp --tmpdir

     $sorted_video_paths
        | each { |p|
            let abs_path = ($p | path expand)
            $"file '($abs_path)'"
        }
        | str join "\n"
        | save --force $temp_file_name

    ffmpeg -hide_banner -loglevel error -f concat -safe 0 -i $temp_file_name -c copy $output
    print $"Successfully merged videos into: ($output)"

    print $"trashing raw videos..."
    $video_paths | each { trash $in }
}
