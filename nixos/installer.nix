{
  pkgs,
  modulesPath,
  secrets,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ./common/minimum.nix
    ./common/sing-box.nix
  ];
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];

  environment.systemPackages = with pkgs; [
    util-linux
    udisks
    git-crypt
    cachix
    btrfs-progs
    (
      let
        cryptKeyFile = builtins.path {
          name = "git-crypt-key";
          path = ../secrets/cryptkey;
        };
      in
      pkgs.writeShellScriptBin "clone-nix-config" ''
        #!/usr/bin/env bash
        set -e

        # Clone the repository if it doesn't exist
        if [ ! -d "/home/nixos/nix-config" ]; then
          echo "Cloning nix-config repository..."
          git clone https://github.com/WeissP/nix-config.git /home/nixos/nix-config
        else
          echo "Repository already exists, updating..."
          cd /home/nixos/nix-config
          git pull
        fi

        # Unlock the repository using the key file
        echo "Unlocking repository with git-crypt..."
        cd /home/nixos/nix-config
        git-crypt unlock ${cryptKeyFile}

        echo "Repository ready at /home/nixos/nix-config"
      ''
    )
    (pkgs.writeShellScriptBin "install-nixos" ''
      #!/usr/bin/env bash
      set -e

      # Default values
      SESSION=""

      # Parse command line arguments
      while [[ $# -gt 0 ]]; do
        case $1 in
          --session)
            SESSION="$2"
            shift 2
            ;;
          *)
            echo "Unknown option: $1"
            echo "Usage: install-nixos --session SESSION"
            exit 1
            ;;
        esac
      done

      # Check required parameters
      if [ -z "$SESSION" ]; then
        echo "Error: Session name is required (--session)"
        exit 1
      fi

      echo "Copying generated hardware-configuration to /home/nixos/nix-config/nixos/$SESSION ..."
      sudo nixos-generate-config --no-filesystems --root /mnt
      cp /mnt/etc/nixos/hardware-configuration.nix /home/nixos/nix-config/nixos/$SESSION/hardware-configuration.nix

      # Prompt for installation
      echo "Disk partitioning complete. Ready to install NixOS using flake."
      read -p "Proceed with installation? (y/N) " -n 1 -r
      echo
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled. The system is mounted at /mnt."
        exit 0
      fi

      # Install NixOS using the flake
      echo "Installing NixOS using flake..."
      sudo nixos-install --flake "/home/nixos/nix-config#$SESSION" \
        --option trusted-substituters "https://weiss.cachix.org https://nix-community.cachix.org https://cache.nixos.org/ https://cache.iog.io" \
        --option trusted-public-keys "weiss.cachix.org-1:2IzFIzVwv8/iIrmz319mWB0KDqGl16eoNF67eX1YNdo= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= sylvorg.cachix.org-1:xd1jb7cDkzX+D+Wqt6TemzkJH9u9esXEFu1yaR9p8H8= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      echo "Installation complete! You can now reboot into your new system."
    '')
    (pkgs.writeShellScriptBin "disko-install" ''
      #!/usr/bin/env bash
      set -e

      # Default values
      CONFIG_FILE="/home/nixos/nix-config/disko/btrfs_system.nix"
      DEVICE=""
      SESSION=""
      USERNAME="weiss"
      SWAP_SIZE="32G"
      USER_ID="1000"
      GROUP_ID="1000"
      DISKO_MODE="destroy,format,mount"

      # Parse command line arguments
      while [[ $# -gt 0 ]]; do
        case $1 in
          --config)
            CONFIG_FILE="$2"
            shift 2
            ;;
          --device)
            DEVICE="$2"
            shift 2
            ;;
          --session)
            SESSION="$2"
            shift 2
            ;;
          --username)
            USERNAME="$2"
            shift 2
            ;;
          --swap-size)
            SWAP_SIZE="$2"
            shift 2
            ;;
          --user-id)
            USER_ID="$2"
            shift 2
            ;;
          --group-id)
            GROUP_ID="$2"
            shift 2
            ;;
          --mode)
            DISKO_MODE="$2"
            shift 2
            ;;
          *)
            echo "Unknown option: $1"
            echo "Usage: disko-install --config CONFIG_FILE --device DEVICE --session SESSION [--username USERNAME] [--swap-size SWAP_SIZE] [--user-id USER_ID] [--group-id GROUP_ID] [--mode DISKO_MODE]"
            exit 1
            ;;
        esac
      done

      # Clone the nix-config repository if it doesn't exist
      if [ ! -d "/home/nixos/nix-config" ]; then
        echo "Cloning nix-config repository..."
        clone-nix-config
      fi


      # Check required parameters
      if [ -z "$CONFIG_FILE" ]; then
        echo "Error: Config file is required (--config)"
        exit 1
      fi

      if [ -z "$DEVICE" ]; then
        echo "Error: Device is required (--device)"
        exit 1
      fi

      if [ -z "$SESSION" ]; then
        echo "Error: Session name is required (--session)"
        exit 1
      fi

      # Create a temporary directory for our work
      TEMP_DIR=$(mktemp -d)
      trap 'rm -rf "$TEMP_DIR"' EXIT

      # Create a temporary disko config with the specified device
      echo "Creating disko configuration..."
      cat > "$TEMP_DIR/disko-config.nix" << EOF
      (import $CONFIG_FILE) {
        myEnv.username = "$USERNAME";
        mainDevice = "$DEVICE";
        swapSize = "$SWAP_SIZE";
        userId = $USER_ID;
        groupId = $GROUP_ID;
      }
      EOF

      sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode $DISKO_MODE "$TEMP_DIR/disko-config.nix"

      # Create user subvolumes manually
      echo "Creating user subvolumes..."
      sudo mkdir -p "/mnt/home/$USERNAME"
      sudo chown "$USER_ID:$GROUP_ID" "/mnt/home/$USERNAME"

      # Create each subvolume with proper permissions
      sudo btrfs subvolume create "/mnt/home/$USERNAME/nix-config"
      sudo btrfs subvolume create "/mnt/home/$USERNAME/projects"
      sudo btrfs subvolume create "/mnt/home/$USERNAME/Documents"
      sudo btrfs subvolume create "/mnt/home/$USERNAME/Downloads"
      sudo btrfs subvolume create "/mnt/home/$USERNAME/games"
      sudo btrfs subvolume create "/mnt/home/$USERNAME/Maildir"

      # Set proper ownership for all created subvolumes
      sudo chown -R "$USER_ID:$GROUP_ID" "/mnt/home/$USERNAME/nix-config"
      sudo chown -R "$USER_ID:$GROUP_ID" "/mnt/home/$USERNAME/projects"
      sudo chown -R "$USER_ID:$GROUP_ID" "/mnt/home/$USERNAME/Documents"
      sudo chown -R "$USER_ID:$GROUP_ID" "/mnt/home/$USERNAME/Downloads"
      sudo chown -R "$USER_ID:$GROUP_ID" "/mnt/home/$USERNAME/games"
      sudo chown -R "$USER_ID:$GROUP_ID" "/mnt/home/$USERNAME/Maildir"

      # Copy nix-config to the mounted system
      echo "Copying nix-config repository to /mnt/home/$USERNAME/nix-config-boot..."
      sudo mkdir -p "/mnt/home/$USERNAME/nix-config-boot"
      sudo cp -r /home/nixos/nix-config/* "/mnt/home/$USERNAME/nix-config-boot/"
      sudo chown -R "$USER_ID:$GROUP_ID" "/mnt/home/$USERNAME/nix-config-boot"

      echo "Disk has been formatted and mounted at /mnt."
      echo "nix-config has been copied to /home/$USERNAME/nix-config-boot on the target system."
      echo "To continue with installation, run: install-nixos --session $SESSION"
    '')
  ];
}
