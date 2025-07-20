open /home/weiss/Documents/chats/errors.md
| lines 
| each {|in| $in | parse "{_}'/mnt/media/hdd1/{v}.mp4'{_}" | get v  }
| flatten
| each {|in| ["/mnt/media/hdd1", $"($in).mp4"] | path join }
| uniq
| each {|in| rm -r ($in | path dirname) }


# $t | parse "{_}'/mnt/media/hdd1/{v}.mp4'{_}"

def main [] {
  let ass_paths = ls `/media/videos/bilibili/**/*.ass` -f | get name
  ls `/media/ytdl-sub/tv-shows/细细的蓝线11/Season */*.mp4` -f
  | get name
  | each { |n|
      let p = ($n | path parse)
      let date = ($p.stem | parse "{date} - {_}").date | first
      let ass = $ass_paths  | where {|n| $n | str contains $date} | first
      let ass_target_path = $p | upsert extension "ass" | path join
      cp $ass $ass_target_path
    }
}

open /home/weiss/projects/JavSP/data/genre_javbus.csv
| each {|row| $"($row.ja)=($row.translate)"}

def back_opus [dir: string] {
cd $dir
let name = ls *.jpg -f | get name | first | path parse | upsert extension opus | path join
cp "old.opus.to_remove" $name
}

ls **/*.opus -f
| get name
| where {|f|
  let stat = ls ($f | path dirname) | where {|n| $n.name | str contains "opus"} 
  if ($stat | length) == 1 {
    return true
  }
  if ($stat | length) >= 3 {
    return false
  }
  let min_size = $stat | get size | math min
  let max_size = $stat | get size | math max
  ($max_size - $min_size) / $min_size > 0.1 
}
| par-each { |f|
let path_comp = $f | path parse 
let tmp_file = $path_comp | upsert stem "old" | path join
mv $f $tmp_file
ffmpeg -i $tmp_file -af "speechnorm=e=5:r=0.00005:l=1,loudnorm=I=-28:LRA=7:tp=-2" $f
}


# let all = open "/home/weiss/Downloads/all.csv" | get number
# let downloaded = open "/home/weiss/Documents/downloaded.csv" | get number
# let to_download = $all | where {$in not-in $downloaded}
# open "/home/weiss/Documents/chats/chat-42-[14-55]-{28.06.2025}.org" --raw | decode utf-8  | lines | where { |$url| $to_download | any { |n| $url | str contains $"N($n)" }} 

# open /home/weiss/Downloads/to_download.txt | lines | each { |url| curl http://192.168.0.33:6800/jsonrpc -H 'Content-Type: application/json' -d $'{"jsonrpc":"2.0","id":"qwer","method":"aria2.addUri","params":["token:1.048596",["($url)"],{ "dir": "/media/audios/tmp" }]}' ; sleep (random int 1..60 | into duration  --unit sec) }



# open "/home/weiss/Documents/chats/chat-42-[14-55]-{28.06.2025}.org" --raw | decode utf-8  | lines | each { { raw: $in, n: ($in | parse '.*N/N(?P<number>\d).*')} } | where { $in.n | is-empty }

# open "/home/weiss/Documents/chats/chat-42-[14-55]-{28.06.2025}.org" --raw | decode utf-8  | lines | each { ($in | parse --regex '.*N/N(?P<number>\d{3}).*' | first) } 

# open "/home/weiss/Documents/chats/chat-42-[14-55]-{28.06.2025}.org" --raw | decode utf-8  | lines | first | parse '.*N/N(?P<number>\d).*'

export def group_by_number [root: string] {
let files = ls $root -f | where type == file | get name

$files
| each {
     let parsed = ($in | path parse).stem | parse "N{number} {rest}"
     let number = ($parsed | first).number
     { number: $"N($number)", filename: $in }
  }
| flatten
| group-by number --to-table 
| each {|row|
    if ("items" in $row) {
       let dir_name = ($row.items.filename | first | path parse).stem
       let dir = $root | path join $"($dir_name)" 
       mkdir $dir
       $row.items.filename | each {|n| cp $n  $"($dir)/"}        
    }
  }
}

export def group_by_stem [] {
let root = "/media/ytdl-sub/podcasts/左為"
ls $root -f
| where type == file
| get name
| each {
     { stem: ($in | path parse).stem, filename: $in }
  }
| flatten
| group-by stem --to-table 
# | each {|row|
    # let dir = $root | path join $row.stem 
    # $dir
    # mkdir $dir
    # $row.items.filename | each {|n|
    #   mv $n $"($dir)/"
    # }
# }
}

export def group_by_authors [root: string] {
cd $root
ls *.mp3 -f
| get name
| each {
     let parsed = ($in | path parse).stem | parse "{title}-{authors}"
     let authors = if ($parsed | is-empty) {
               "小野猫"
          } else {
               ($parsed | first).authors | str replace --all " " ","
          }  
     { authors: $authors, filename: $in }
  }
| flatten
| group-by authors --to-table 
| each {|row|
    let dir = $root | path join $row.authors
    mkdir $dir
    $row.items.filename | each {|n|
      let dir_name = $dir | path join ($n | path parse).stem
      mkdir $dir_name
      mv $n $"($dir_name)/"
    }
    group_by_number $dir
}
}

export def main [] {
ls -f  
| where type == dir
| get name
| each {|n|
  let new = $n | path parse | upsert stem {|r| $r.stem | str substring 13.. } | path join
  mv $n $new
}

}
