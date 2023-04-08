# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, secrets, ... }: {
  # You can import other NixOS modules here
  imports = [ ../common/personal.nix ./hardware-configuration.nix ];

  # FIXME: Add the rest of your current configuration

  networking.hostName = "vmware";

  # boot.loader = {
  #   systemd-boot.enable = true;
  #   efi.canTouchEfiVariables = true;
  #   # VMware, Parallels both only support this being 0 otherwise you see
  #   # "error switching console mode" on boot.
  #   systemd-boot.consoleMode = "0";
  # };

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  virtualisation.vmware.guest.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [ secrets.ssh."163".public ];
  users.users = {
    weiss = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [ secrets.ssh."163".public ];
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };
  nix.settings.trusted-users = [ "root" "weiss" ];

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      permitRootLogin = "yes";
      KbdInteractiveAuthentication = true;
    };
  };

  security.sudo.extraRules = [{
    users = [ "weiss" ];
    commands = [{
      command = "ALL";
      options =
        [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
    }];
  }];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
