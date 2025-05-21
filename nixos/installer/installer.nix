{
  pkgs,
  modulesPath,
  secrets,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ../common/minimum.nix
    ../common/sing-box.nix
  ];
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];

  environment.variables.GIT_CRYPT_PATH = builtins.path {
    name = "git-crypt-key";
    path = ../../secrets/cryptkey;
  };
  environment.systemPackages = with pkgs; [
    util-linux
    udisks
    git-crypt
    cachix
    rsync
    btrfs-progs
    nushell
    (
      let
        script = builtins.path {
          name = "install_script.nu";
          path = ./install.nu;
        };
      in 
      pkgs.writeShellScriptBin "go" ''
        #!/usr/bin/env bash
        set -e
        sudo loadkeys de
        nu -e "use ${script} * ; show-disk"
      ''
    )
  ];
}
