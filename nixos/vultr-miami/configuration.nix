{ inputs, outputs, lib, config, myEnv, pkgs, secrets, configSession, ... }:
with myEnv; {
  imports = [ ../common/minimum.nix ];
  time.timeZone = "America/New_York";
  networking.hostName = "${username}-${configSession}";

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services = {
    openssh = {
      enable = true;
      settings = {
        permitRootLogin = "yes";
        KbdInteractiveAuthentication = true;
      };
    };
  };

  users.users."${username}" = {
    hashedPassword = secrets.${configSession}.password.hashed;
  };

  virtualisation.docker.enable = true;
  security.sudo.extraRules = [
    # Allow execution of any command by all users in group sudo,
    # requiring a password.
    {
      groups = [ "sudo" ];
      commands = [ "ALL" ];
    }
  ];

  system.stateVersion = "23.05";
}
