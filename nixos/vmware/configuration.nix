# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, secrets, ... }: {
  # You can import other NixOS modules here
  imports = [ ../common/minimum.nix ../common/personal.nix ];
  time.timeZone = "Europe/Berlin";
  networking.hostName = "vmware";

  virtualisation.vmware.guest.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [ secrets.ssh."163".public ];

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      permitRootLogin = "yes";
      KbdInteractiveAuthentication = true;
    };
  };

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    okular
    oxygen
    khelpcenter
    konsole
    plasma-browser-integration
    print-manager
  ];

  security.sudo.extraRules = [{
    users = [ "weiss" ];
    commands = [{
      command = "ALL";
      options =
        [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
    }];
  }];
}
