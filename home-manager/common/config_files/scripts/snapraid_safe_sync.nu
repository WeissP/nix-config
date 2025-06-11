use /home/weiss/nix-config/home-manager/common/config_files/scripts/logfile.nu

export def main [] {
   logfile set-log-file "/home/weiss/nix-config/home-manager/common/config_files/scripts/exp.log"
   let msg = snapraid sync e>| str trim
   logfile warning $msg
   # sudo snapraid sync o> 

   loop {
     try {
       let msg = snapraid sync e>| str trim
       snapraid touch
       snapraid sync
       break
     } catch { |err|
       let msg = $err.msg  
       if (($msg | str contains "The lock file") and ($msg | str contains "is already in use!")) {
         logfile info "Snapraid is syncing, waiting..."
         sleep 30sec
         continue
       } else {
         logfile error $"Failed to start snapraid syncing: ($msg)."
         error make $err
       }
     }
   }
}
