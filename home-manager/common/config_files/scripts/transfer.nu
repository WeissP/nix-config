def "nu-complete host_path" [] {
   ["/home/weiss/Downloads/"]
}

def "nu-complete server_path" [] {
   ["/media/audios/", "/media/videos/", "/home/weiss/Downloads/videos"]
}

export def main [from_path: path, to_path: string@"nu-complete server_path", --move] {
    rsync -PamAXvtu -e ssh $from_path $"home-server:($to_path)"
    if $move {
       trash $from_path
    }
}
