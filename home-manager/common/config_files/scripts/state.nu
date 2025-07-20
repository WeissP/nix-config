export def state_path [] {
  let p = $env | get --ignore-errors my_state_location
          | default (let state_dir = $env | get --ignore-errors xdg_state_home | default "~/.local"; $"($state_dir)/my_state/my_state.json")
          | path expand 
  if not ($p | path exists) {
    mkdir ($p | path dirname)
    {} | save $p 
  }
  $p
}

export def read [] {
   let p = state_path 
   open $p --raw | from json
}

export def write [nested_key: string, v: string] {
   let p = state_path 
   let cp = $nested_key | split row "." | into cell-path 
   open $p --raw | from json | upsert $cp v
   $v
}

export def delete [key: string] {
   let p = state_path 
   open $p --raw | from json | reject $key | save -f $p
   read
}

export def main [] {state_path}
