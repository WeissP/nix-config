{ config, myEnv, secrets, lib, pkgs, ... }:
with myEnv; {
  programs.nushell = lib.mkMerge [{
    enable = true;
    configFile.text = ''
      $env.config = {
         show_banner: false
      }
      $env.config = ($env.config | upsert hooks.env_change.PWD {|config|
              [{
              condition: {|_, after| $after | path join 'init.nu' | path exists}
              code: "print 'loading init.nu ...'; use init.nu *"
            }
            ]
      })
      def retry_until [
          --max-retries: int = 10 # Maximum number of retries
          --delay: duration = 10ms # Delay between retries
          --cmd: string # Command to execute
      ] {
          let retries = 0

          while ($retries < $max_retries) {
              try {
                  nu $cmd
                  break
              } catch {
                  $retries = ($retries + 1)
                  sleep $delay
              }
          }

          if ($retries == $max_retries) {
              print "Maximum retries reached. Operation failed."
          }
      }

      use task.nu
    '';
  }];
}
