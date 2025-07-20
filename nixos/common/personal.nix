{
  pkgs,
  lib,
  myEnv,
  ...
}:
with lib;
with myEnv;
{
  imports =
    [
      ./psql.nix
      ./syncthing.nix
      ./zsh.nix
      ./uxplay.nix
      ./sunshine.nix
      ./fonts.nix
      ./gluqloFont.nix
      ./stylix.nix
    ]
    ++ (
      if myEnv.arch == "linux" then
        [
          ./display.nix
        ]
      else
        [ ]
    );

  services = {
    joycond.enable = true;
    geoclue2.enable = true;
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        accelSpeed = "0.5"; # float number between -1 and 1.
      };
    };
    pulseaudio = {
      enable = false;
      support32Bit = true;
      # package = pkgs.pulseaudioFull;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
    blueman.enable = false;
    myPostgresql = {
      enable = true;
    };
  };

  programs = {
    mosh.enable = true;
    zsh.enable = true;
    git = {
      enable = true;
    };
  };

  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      kora-icon-theme
      adwaita-icon-theme
      protontricks
      git-crypt
      ripgrep
      cachix
      killall
      locale
      unzip
      zip
      pwvucontrol
      xdotool
      wezterm
      babashka
      udisks
      xdg-user-dirs
    ];
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable32Bit = true;
  };

  virtualisation = {
    # docker = {
    #   enable = true;
    #   storageDriver = "btrfs";
    # };
    virtualbox.host.enable = true;
  };
  users.extraGroups.vboxusers.members = [ "$username" ];
}
