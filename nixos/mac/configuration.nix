{ inputs, outputs, lib, myLib, config, pkgs, secrets, myEnv, ... }:
with myEnv; {
  imports = [ ../common/minimum.nix ../common/psql.nix ];

  services.myPostgresql = {
    enable = true;
    package = pkgs.lts.postgresql_15;
  };
  networking.hostName = "Bozhous-Air";

  launchd.user.agents.webman-cli.serviceConfig = {
    ProgramArguments =
      [ "${pkgs.webman.webman-cli.outPath}/bin/webman-cli" "provide" ];
    StandardErrorPath = "${homeDir}/.config/webman/cli.err.log";
    StandardOutPath = "${homeDir}/.config/webman/cli.out.log";
    StartCalendarInterval =
      map (min: { Minute = min; }) (myLib.interval.minutes 1);
  };
  launchd.user.agents.webman-server.serviceConfig = {
    KeepAlive = true;
    ProgramArguments =
      [ "${pkgs.webman.webman-server.outPath}/bin/webman-server" ];
    StandardErrorPath = "${homeDir}/.config/webman/server.err.log";
    StandardOutPath = "${homeDir}/.config/webman/server.out.log";
  };
  # launchd.user.agents.mail-sync.serviceConfig = {
  #   ProgramArguments = [ "${homeDir}/.nix-profile/bin/mbsync" "-a" ];
  #   StandardErrorPath = "${homeDir}/.config/mbsync/mbsync.err.log";
  #   StandardOutPath = "${homeDir}/.config/mbsync/mbsync.out.log";
  #   StartCalendarInterval =
  #     map (min: { Minute = min; }) (myLib.interval.minutes 10);
  # };
}

