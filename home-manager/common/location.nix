{
  inputs,
  outputs,
  myEnv,
  lib,
  config,
  pkgs,
  username,
  location,
  secrets,
  myLib,
  ...
}:
with myEnv;
lib.mkMerge [
  (ifLinuxPersonal {
    systemd.user = {
      services = {
        mapwacom = {
          Unit.Description = "map main screen to wacom";
          Install.WantedBy = [ "autostart.target" ];
          Service = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = ''${scriptsDir}/mapwacom.sh --device-regex ".*Wacom.*" -s "DisplayPort-0"'';
            PassEnvironment = "PATH";
          };
        };
      };
    };
  })
]
