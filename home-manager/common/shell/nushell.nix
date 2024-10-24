{ config, myEnv, secrets, lib, pkgs, ... }:
with myEnv; {
  home.packages = [ pkgs.nufmt ];
  programs.nushell = lib.mkMerge [{
    enable = true;
    # check options in https://github.com/nushell/nushell/blob/main/crates/nu-utils/src/sample_config/default_config.nu
    configFile.text = ''
      $env.config = {
         show_banner: false
         render_right_prompt_on_last_line: false
         history: {
             sync_on_enter: false 
             file_format: "sqlite"
             isolation: true
         }
      }
      $env.config = ($env.config | upsert hooks {
          env_change: {
              PWD: [
                  {
                    condition: {|_, after| $after | path join 'init.nu' | path exists}
                    code: "print 'loading init.nu ...'; use init.nu *"
                  }
              ]
          }
      })
      use task.nu

      def create [p: string] {            
          let full = $p | path expand
          mkdir ($full | path dirname) 
          touch $full
      }
      
      def sync_videos [] {
          echo "Sync videos from Mac to Desktop"
          rsync -PamAXvtu -e ssh ${homeDir}/Downloads/videos/rsync weiss@${secrets.nodes.Desktop.localIp}:/home/weiss/Downloads/videos/ 
          echo "Sync videos from Desktop to Mac"
          rsync -PamAXvtu -e ssh weiss@${secrets.nodes.Desktop.localIp}:/home/weiss/Downloads/videos/rsync ${homeDir}/Downloads/videos/ 
      }
    '';
  }];
}
