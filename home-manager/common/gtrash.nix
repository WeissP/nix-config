{
  pkgs,
  lib,
  myEnv,
  config,
  secrets,
  inputs,
  outputs,
  ...
}:
with myEnv;
{
  home.packages = with pkgs; [ gtrash ];
  systemd.user = {
    services = {
      gtrash-prune = {
        Unit.Description = "Prune trash older than 30 days";
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.gtrash}/bin/gtrash prune --day 30";
        };
      };
    };
    timers = {
      gtrash-prune = {
        Unit.Description = "Run gtrash prune daily";
        Timer = {
          OnCalendar = "daily";
          Persistent = true; # Run on next boot if missed
          Unit = "gtrash-prune.service";
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };
    };
  };
}
