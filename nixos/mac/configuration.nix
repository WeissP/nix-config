{
  inputs,
  outputs,
  lib,
  myLib,
  config,
  pkgs,
  secrets,
  myEnv,
  ...
}:
with myEnv;
{
  imports = [
    ../common/minimum.nix
    ../common/sing-box.nix
    ../common/psql.nix
    ../common/zsh.nix
  ];

  networking = {
    hostName = "Bozhous-Air";
  };

  nixpkgs.config.allowBroken = false;
  services = {
    myPostgresql = {
      enable = true;
      package = pkgs.lts.postgresql_15;
    };
    karabiner-elements.enable = false; # no multitouch support
  };

  launchd.user.agents = {
    webman-cli.serviceConfig = {
      ProgramArguments = [
        "${pkgs.webman.webman-cli.outPath}/bin/webman-cli"
        "provide"
      ];
      StandardErrorPath = "${homeDir}/.config/webman/cli.err.log";
      StandardOutPath = "${homeDir}/.config/webman/cli.out.log";
      StartCalendarInterval = map (min: { Minute = min; }) (myLib.interval.minutes 1);
    };
    webman-server.serviceConfig = {
      KeepAlive = true;
      ProgramArguments = [ "${pkgs.webman.webman-server.outPath}/bin/webman-server" ];
      StandardErrorPath = "${homeDir}/.config/webman/server.err.log";
      StandardOutPath = "${homeDir}/.config/webman/server.out.log";
    };

    mail-sync.serviceConfig = {
      ProgramArguments = [
        "${userBin "mbsync"}"
        "-a"
      ];
      StandardErrorPath = "${homeDir}/.config/mbsync/mbsync.err.log";
      StandardOutPath = "${homeDir}/.config/mbsync/mbsync.out.log";
      StartCalendarInterval = map (min: { Minute = min; }) (myLib.interval.minutes 10);
    };
  };

  homebrew = {
    enable = true;
    brews = [ "pdfpc" ];
    casks = [
      "steam"
      "floorp"
      "flameshot"
      "apptivate"
      "font-cascadia-mono-pl"
      "font-fira-code"
      "qq"
      "baidunetdisk"
      "font-jetbrains-mono"
      "font-lato"
      "font-liberation"
      "squirrel"
      "font-sarasa-gothic"
      "font-source-code-pro"
      "syncthing"
      "font-cascadia-code"
      "font-cascadia-code-pl"
      "font-cascadia-mono"
      "raycast"
      "xournal-plus-plus"
      "macfuse"
      # "karabiner-elements"
    ];

  };
}
