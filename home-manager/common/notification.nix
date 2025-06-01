{
  pkgs,
  lib,
  config,
  myLib,
  secrets,
  ...
}:
let
  bins =
    with pkgs;
    myLib.mkNuBinPath [
      libnotify
      ffmpeg
    ];
  script = (
    pkgs.writers.writeNuBin "listen-ntfy" ''
      const topics = ${secrets.ntfy.topicRecordInNu}
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
         $env.Path = ${bins}
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
