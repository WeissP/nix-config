{
  inputs,
  outputs,
  myEnv,
  lib,
  myLib,
  config,
  pkgs,
  ...
}:
with myEnv;
{
  imports = lib.flatten [
    ../common/minimum.nix
    (lib.optional (builtins.elem "personal" usage) ../common/personal.nix)
    (lib.optional (builtins.elem "aria-server" usage) ../common/aria.nix)
    (lib.optional (builtins.elem "local-server" usage) ../common/localServer.nix)
    (lib.optional (builtins.elem "remote-server" usage) ../common/remoteServer.nix)
    (lib.optional (builtins.elem "router" usage) ../common/router.nix)
  ];
  config =
    with lib;
    with myEnv;
    mkMerge [
      (ifServer {
        systemd.user.services.server-autostart = {
          Unit.Description = "server autostart";
          Unit.After = [ "default.target" ];
          Install.WantedBy = [ "default.target" ];
          Service = {
            Type = "oneshot";
            PassEnvironment = "PATH";
            RemainAfterExit = true;
            ExecStart = "${pkgs.systemd}/bin/systemctl --user start autostart.target";
          };
        };
      })
    ];
}
