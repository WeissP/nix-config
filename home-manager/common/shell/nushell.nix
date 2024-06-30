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
      $env.config = ($env.config | upsert hooks.env_change.PWD {|config|
              [{
              condition: {|_, after| $after | path join 'init.nu' | path exists}
              code: "print 'loading init.nu ...'; use init.nu *"
            }
            ]
      })
      use task.nu
    '';
  }];
}
