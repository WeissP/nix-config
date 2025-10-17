{
  pkgs,
  lib,
  myEnv,
  ...
}:
with lib;
with myEnv;
{
  imports = [
    ./psql.nix
    ./syncthing.nix
    ./zsh.nix
    ./uxplay.nix
    ./fonts.nix
    ./gluqloFont.nix
    ./stylix.nix
  ]
  ++ (lib.optional (builtins.elem configSession [
    "desktop"
    "laptop"
  ]) ./steam)
  ++ (lib.optional (configSession == "desktop" || configSession == "mini") ./keymapper.nix)
  ++ (lib.optional (myEnv.arch == "linux") ./display.nix);

  services = {
    # Enable autodiscovery of network printers
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };

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
    dconf.enable = true;
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
    # virtualbox.host.enable = true;
  };
  users.extraGroups.vboxusers.members = [ "$username" ];
}
