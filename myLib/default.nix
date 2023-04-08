{ lib, pkgs, ... }: {
  mergeAttrList =
    lib.lists.foldr (elem: res: lib.trivial.mergeAttrs elem res) { };
  homeDir = username: "/home/${username}";
  service = {
    startup = { cmds, description ? "STARTUP"
      , wantedBy ? [ "graphical-session.target" ] }: {
        Unit.Description = description;
        Install.WantedBy = wantedBy;
        Service = {
          Type = "simple";
          ExecStart = cmds;
        };
      };
  };
}
