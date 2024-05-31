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

      use task.nu
    '';
  }];
}
