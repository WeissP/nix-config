{
  pkgs,
  modulesPath,
  secrets,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ./common/sing-box.nix
  ];
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root = {
    openssh.authorizedKeys.keys = [ secrets.ssh."163".public ];
  };
  environment = {
    systemPackages = with pkgs; [
      util-linux
      udisks
      git-crypt
    ];
  };

  systemd.services.clone-nix-config = {
    description = "Clone nix-config repository and unlock with git-crypt";
    path = with pkgs; [
      git
      git-crypt
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/home/nixos";
    };

    script =
      let
        cryptKeyFile = builtins.path {
          name = "git-crypt-key";
          path = ../secrets/cryptkey;
        };
      in
      ''
        # Clone the repository if it doesn't exist
        if [ ! -d "/home/nixos/nix-config" ]; then
          git clone https://github.com/WeissP/nix-config.git /home/nixos/nix-config
        fi

        # Unlock the repository using the key file
        cd /home/nixos/nix-config
        git-crypt unlock ${cryptKeyFile}
      '';
  };
}
