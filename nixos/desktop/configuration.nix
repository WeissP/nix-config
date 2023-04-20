{ inputs, outputs, lib, config, myEnv, pkgs, secrets, ... }:
with myEnv; {
  imports = [ ../common/minimum.nix ../common/personal.nix ];
  time.timeZone = "Europe/Berlin";
  networking.hostName = "${username}_Desktop";

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      permitRootLogin = "yes";
      KbdInteractiveAuthentication = true;
    };
  };

  security.sudo.extraRules = [
    # Allow execution of any command by all users in group sudo,
    # requiring a password.
    {
      groups = [ "sudo" ];
      commands = [ "ALL" ];
    }
  ];
}
