export def main [from_path: string, to_path: string, --move] {
    rsync -PamAXvtu -e ssh $from_path $"weiss@($env.HOME_SERVER_IP):($to_path)"
    if $move {
       trash $from_path
    }
}

export def move_videos [from_path: string] {
  main $from_path "/home/weiss/Downloads/videos" --move
}

