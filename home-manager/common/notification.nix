{
  pkgs,
  lib,
  config,
  myLib,
  secrets,
  ...
}:
let
  inherit (myLib) quote;
  alertSound = myLib.resource "sound/notify_sound_alert.mp3";
  normalSound = myLib.resource "sound/notify_sound_normal.mp3";
  script = (
    pkgs.additions.writeNuBinWithConfig "listen-ntfy"
      {
        env = {
          Path =
            with pkgs;
            myLib.mkNuBinPath [
              libnotify
              ffmpeg
            ];
          notify_sound_3 = quote normalSound;
          notify_sound_4 = quote alertSound;
          notify_sound_5 = quote alertSound;
        };
      }
      ''
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
           let priority = $env.priority | into int 
           notify-send --urgency=$"(priority-to-urgency $priority)" $env.title $env.message 
           play-sound $priority
        }
      ''
  );
  scriptPath = lib.getExe script;
  format = pkgs.formats.yaml { };
  settings = {
    subscribe = map (topic: {
      inherit topic;
      # Ntfy directly run sh to the command and can't be changed
      command = "${lib.getExe pkgs.nushell} -c ${scriptPath}";
    }) (builtins.attrValues secrets.ntfy.topics);
  };
  ntfyExe = lib.getExe' pkgs.ntfy-sh "ntfy";
  yamlConfigPath = format.generate "ntfy-client.yaml" settings;
  p =
    with pkgs;
    lib.makeBinPath [
      coreutils
      bash
    ];
in
{
  home.packages = [ pkgs.ntfy-sh ];
  systemd.user.services."ntfy-client" = {
    Unit = {
      Description = "ntfy client";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${ntfyExe} subscribe --config ${yamlConfigPath} --from-config";
      Restart = "on-failure";
      Environment = [ "PATH=${p}" ];
    };
    Install.WantedBy = [ "default.target" ];
  };
}
