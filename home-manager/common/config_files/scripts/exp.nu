open /home/weiss/Downloads/to_download.txt | lines | each { |url| curl http://192.168.2.33:6800/jsonrpc -H 'Content-Type: application/json' -d $'{"jsonrpc":"2.0","id":"qwer","method":"aria2.addUri","params":["token:1.048596",["($url)"],{ "dir": "/media/audios/tmp" }]}' ; sleep (random int 1..60 | into duration  --unit sec) }

mkdir /home/weiss/.config/singbox_config/old ; ls *.json -f | get name | each { |link_name|
readlink $link_name | cp $in /home/weiss/.config/singbox_config/old/   
}

ls -f /media/videos/porn/metatube/run/media/weiss/Seagate_Backup/videos/porn
| get name
| each {|n|
let parsed = $n | path parse
let dir = "/media/videos/porn/metatube" | path join $parsed.stem
mkdir $dir
mv $n $"($dir)/"
} 



rsync -av --progress --files-from=/home/weiss/to_sync.txt / /mnt/media/hdd1/videos/porn/metatube/


let skip = open /home/weiss/skip.txt | lines
let bangos = open /home/weiss/saved-bangos.txt | lines
/media/videos/porn
ls -f /run/media/weiss/Seagate_Backup/videos/porn
| get name
| where {|in|
let name = $in | path basename 
let in_bango = $bangos | any {|bango| $name | str contains --ignore-case $bango } 
not ($name in $skip) and not $in_bango
}
| save /home/weiss/to_sync.txt

ls `/media/videos/porn/#processed/**/*.nfo` -f
| get name
| each { |in|
 let dir = $in | path dirname
 let bango = ($dir | path basename | parse "[{bango}]{_}").bango  
 {dir: $dir, bango: $bango}
}
| where {|in| (ls $in.dir | get size | math max) > 100MB } 
| each {|in| $in.bango | first}
| save /home/weiss/saved-bangos.txt

 
| each {|in| $in.bango | first}
| 

ls | get size | math max 

| each { |in| ($in | path parse).stem | parse "" }

open /home/weiss/Documents/chats/errors.md
| lines 
| each {|in| $in | parse "{_}'/mnt/media/hdd1/{v}.mp4'{_}" | get v  }
| flatten
| each {|in| ["/mnt/media/hdd1", $"($in).mp4"] | path join }
| uniq
| each {|in| rm -r ($in | path dirname) }


# $t | parse "{_}'/mnt/media/hdd1/{v}.mp4'{_}"
# ls /media/videos/bilibili/**/*.ass -a | where modified > ((date now) - 1day)


 # | where modified > ((date now) - 1day)
let ass_paths = ls /media/videos/bilibili/**/*.ass -af  | get name
ls `/media/ytdl-sub/tv-shows/勒夫防御性驾驶/Season */*.mp4` -f
| get name
| each { |n|
    let p = ($n | path parse)
    let date = ($p.stem | parse "{date} - {_}").date | first
    let found_ass = $ass_paths  | where {|n| $n | str contains $date} 
    if ($found_ass | is-not-empty) {
      let ass_target_path = $p | upsert extension "ass" | path join
      cp ($found_ass | first) $ass_target_path    
    }
  }

ls `/media/ytdl-sub/tv-shows/勒夫防御性驾驶/Season */*.mp4` -f
| get name
| where { |n|
    let p = ($n | path parse)
    let date = ($p.stem | parse "{date} - {_}").date | first
    let ass = $ass_paths  | where {|n| $n | str contains $date} 
    $ass | is-empty 
  }


def main [] {

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
