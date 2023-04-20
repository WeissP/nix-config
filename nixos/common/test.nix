{ pkgs, lib, myLib, myEnv, config, inputs, outputs, ... }:
with lib;
with myEnv; {
  nix = mkMerge [
    {
      # This will add each flake input as a registry
      # To make nix3 commands consistent with your flake
      registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

      # This will additionally add your inputs to the system's legacy channels
      # Making legacy nix commands consistent as well, awesome!
      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
        config.nix.registry;

      settings = mkMerge [
        {
          experimental-features = "nix-command flakes";
          auto-optimise-store = false;
        }
        (ifLinux { trusted-users = [ "root" "${username}" ]; })
      ];
    }
    (ifDarwin {
      extraOptions = "extra-platforms = aarch64-darwin x86_64-darwin";
    })
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.weissNur
      outputs.overlays.lts
    ];
    config = { allowUnfree = true; };
  };

  users.users."${username}" = mkMerge [
    { home = homeDir; }
    (ifLinux {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [ secrets.ssh."163".public ];
      extraGroups = [ "wheel" "networkmanager" ];
    })
  ];

  services = mkMerge [
    (ifDarwin { nix-daemon.enable = true; })
    (ifLinux {
      printing.enable = true;
      dbus.packages = [ pkgs.gcr ];
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    })
    (ifLinuxPersonal {
      xserver = {
        enable = true;
        autorun = true;
        libinput.enable = true;
        layout = "de";
        autoRepeatDelay = 230;
        autoRepeatInterval = 30;
        # Enable automatic login for the user.
        displayManager.autoLogin.enable = true;
        displayManager.autoLogin.user = "weiss";
      };
    })
  ];

  security = mkMerge [
    (ifDarwin { pam.enableSudoTouchIdAuth = true; })
    (ifLinux { rtkit.enable = true; })
  ];

  programs = mkMerge [
    { nix-index.enable = true; }
    (ifPersonal { gnupg.agent = { enable = true; }; })
    (ifLinuxPersonal { gnupg.agent.pinentryFlavor = "gnome3"; })
    (ifDarwin { zsh.enable = true; })
  ];

  environment = mkMerge [
    {
      variables = { LANG = "en_US.UTF-8"; };
      systemPackages = with pkgs; [
        git
        git-crypt
        vim
        cachix
        fd
        killall
        locale
      ];
    }
    (ifPersonal { systemPackages = with pkgs; [ gnupg pass ]; })
    (ifLinuxPersonal {
      sessionVariables = {
        LEDGER_FILE = "\${HOME}/finance/2021.journal";
        POSTGIS_DIESEL_DATABASE_URL = "postgres://weiss@localhost/digivine";
      };
    })
  ];

  system = mkMerge [
    (ifDarwin { stateVersion = 4; })
    (ifLinux { stateVersion = "22.11"; })
  ];
}
