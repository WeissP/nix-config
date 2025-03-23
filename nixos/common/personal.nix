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
    ./autorandr.nix
    ./xmonad
    ./psql.nix
    ./syncthing.nix
    ./zsh.nix
    ./uxplay.nix
    ./sunshine.nix
    ./fonts.nix
    ./gluqloFont.nix
  ];

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
    xserver = {
      enable = true;
      autorun = true;
      xkb = {
        layout = "de";
        variant = ",nodeadkeys";
      };
      wacom.enable = true;
      autoRepeatDelay = 230;
      autoRepeatInterval = 30;
    };
    blueman.enable = true;
    myPostgresql = {
      enable = true;
    };
  };

  programs = {
    zsh.enable = true;
    git = {
      enable = true;
    };
  };

  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      protontricks
      git-crypt
      ripgrep
      cachix
      killall
      locale
      unzip
      zip
      pavucontrol
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
    };
    graphics.enable32Bit = true;
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

}
