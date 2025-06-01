#! /nix/store/ywp33ksgp2v32g0dwril2ds1rlri1kp8-nushell-0.104.0/bin/nu --no-config-file

def priority-to-urgency [p: int] {
   if ($p <= 2) {
      "low"
   } else if ($p == 3) {
      "normal"
   } else {
      "critical"
   }
}
 
def play-sound [priority: int] {
   let sound = $env | get --ignore-errors $"notify_sound_($priority)"
   if ($sound | is-not-empty) {
      ffplay -nodisp -autoexit $sound o+e> /dev/null    
   }
}

export def main [] {
   play-sound $env.priority
   notify-send --urgency=(priority-to-urgency ($env.priority | into int)) $env.title $env.message
}
