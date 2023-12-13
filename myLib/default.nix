{ lib, pkgs, myNixRepo, ... }:
with lib; rec {
  genEnv = env:
    with env; rec {
      ifDarwin = optionalAttrs (arch == "darwin");
      ifLinux = optionalAttrs (arch == "linux");
      ifPersonal = optionalAttrs (usage == "personal");
      ifServer = optionalAttrs (usage == "server");
      ifLinuxPersonal = optionalAttrs (arch == "linux" && usage == "personal");
      ifDarwinPersonal =
        optionalAttrs (arch == "darwin" && usage == "personal");
      username = env.username;
      arch = env.arch;
      usage = env.usage;
      homeDir = if (arch == "darwin") then
        "/Users/${username}"
      else
        "/home/${username}";
      nixDir = "${homeDir}/nix-config";
      scriptsDir = "${homeDir}/scripts";
      financeDir = "${homeDir}/finance";
      systemBin = binary:
        if arch == "linux" then
          "/run/current-system/sw/bin/${binary}"
        else
          binary;
      userBin = binary: "/etc/profiles/per-user/${username}/bin/${binary}";
      ensurePsqlDb = dbName:
        service.startup {
          cmds = "${scriptsDir}/ensure_psql_db.sh ${dbName}";
          description = "ensure PostgreSQL database ${dbName}";
        };
    };
  resource = path: myNixRepo + "/resources/" + path;

  mergeAttrList = lists.foldr (elem: res: trivial.mergeAttrs elem res) { };
  interval = { minutes = m: filter (t: trivial.mod t m == 0) (range 1 59); };
  service = {
    startup =
      { cmds, description ? "STARTUP", wantedBy ? [ "initrd.target" ] }: {
        Unit.Description = description;
        Install.WantedBy = wantedBy;
        Service = {
          Type = "simple";
          ExecStart = cmds;
        };
      };
  };
}
