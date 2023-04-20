{ inputs, outputs, lib, config, myEnv, pkgs, secrets, ... }:
with myEnv; {
  imports = [ ../common/minimum.nix ../common/personal.nix ];
  time.timeZone = "Europe/Berlin";
  networking.hostName = "${username}_Desktop";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    {
      users = [ "weiss" ];
      commands = [{
        command = "ALL";
        options =
          [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
      }];
    }
  ];

  system.stateVersion = "23.05";
}
