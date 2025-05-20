# Helper function for disko-install
# Clones/updates the nix-config repository and unlocks it with git-crypt.
# This function assumes 'git' and 'git-crypt' are in PATH.
# The 'nixos' user in the installer environment should have these available.
# It expects GIT_CRYPT_PATH environment variable to be set.
export def clone-and-unlock [] {
    let key_file_path = $env.GIT_CRYPT_PATH
    if ($key_file_path | is-empty) {
        error make { msg: "GIT_CRYPT_PATH environment variable is not set." }
    }
    let repo_url = "https://github.com/WeissP/nix-config.git"
    let target_dir = "/home/nixos/nix-config"

    if not ($target_dir | path exists) {
        print $"Cloning nix-config repository from ($repo_url) to ($target_dir)..."
        ^git clone $repo_url $target_dir
        if $env.LAST_EXIT_CODE != 0 {
            error make { msg: $"Failed to clone repository ($repo_url)" }
        }
    } else {
        print $"Repository ($target_dir) already exists, updating..."
        # Use a block to change directory temporarily for git pull
        do {
            cd $target_dir
            ^git pull
            if $env.LAST_EXIT_CODE != 0 {
                error make { msg: $"Failed to pull repository ($target_dir)" }
            }
        }
    }

    print $"Unlocking repository ($target_dir) with git-crypt using key ($key_file_path)..."
    if not ($key_file_path | path exists) {
        error make { msg: $"Git-crypt key file not found: ($key_file_path)" }
    }

    # Use a block to change directory temporarily for git-crypt unlock
    do {
        cd $target_dir
        ^git-crypt unlock $key_file_path
        if $env.LAST_EXIT_CODE != 0 {
            error make { msg: $"Failed to unlock repository ($target_dir) with git-crypt. Ensure key is correct and git-crypt is configured." }
        }
    }
    print $"Repository ($target_dir) ready."
}

# Generates a Disko configuration file specifically for home_server.nix.
export def generate-home-server-disko-config [
    --mainDevice: string,                                       # The main SSD device (e.g., /dev/nvme0n1). Required.
    --hhd4t: string,                                            # The 4TB HDD device for backups (e.g., /dev/sda). Required.
    --hhd8tArray: list<string>,                                 # List of 8TB HDD devices for media (e.g., ["/dev/sdb" "/dev/sdc"]). Required.
    --username: string = "weiss",                               # Username for the new system.
    --swapSize: string = "32G",                                 # Size of the swapfile.
    --userId: string = "1000",                                  # User ID for the new user.
    --groupId: string = "1000",                                 # Group ID for the new user.
    --output_disko_config_path: path = "/home/nixos/disko-config.nix", # Path to save the generated disko configuration file.
    --base_config_file: string = "/home/nixos/nix-config/disko/home_server.nix" # Absolute path to the base disko Nix file.
] {
    if ($mainDevice | is-empty) { error make { msg: "--mainDevice is required" } }
    if ($hhd4t | is-empty) { error make { msg: "--hhd4t is required" } }
    if ($hhd8tArray | is-empty) { error make { msg: "--hhd8tArray is required and must be a non-empty list of device paths" } }

    clone-and-unlock

    if not ($base_config_file | path exists) {
        error make { msg: $"Base Disko config file not found: ($base_config_file). Ensure it is an absolute path and the file exists." }
    }

    # Format the hhd8tArray for Nix: e.g., [ "/dev/sdb" "/dev/sdc" ]
    let hhd8tArray_nix_string = ($hhd8tArray | each {|p| $"\"/dev/($p)\""} | str join " ")

    let disko_config_content = $"{ lib, ... }:\(import ($base_config_file)) {
      inherit lib;
      myEnv.username = "($username)";
      mainDevice = "/dev/($mainDevice)";
      hhd4t = "/dev/($hhd4t)";
      hhd8tArray = [ ($hhd8tArray_nix_string) ];
      swapSize = "($swapSize)";
      userId = ($userId | into int);
      groupId = ($groupId | into int);
    }"

    let abs_output_path = ($output_disko_config_path | path expand)
    $disko_config_content | save -f $abs_output_path
    print $"Generated Home Server disko configuration written to ($abs_output_path)"
    print "To apply this configuration, run: apply-disko-config"
}

# Applies a Disko configuration, formats/mounts disks, and prepares user subvolumes.
export def apply-disko-config [
    --generated_disko_config_path: path =  "/home/nixos/disko-config.nix",    # Path to the generated disko configuration file. This parameter is required.
    --mode: string = "destroy,format,mount",# Disko mode (e.g., destroy,format,mount)
    --username: string = "weiss",           # Username for the new system (for subvolumes and ownership)
    --user_id: string = "1000",             # User ID for the new user
    --group_id: string = "1000",            # Group ID for the new user
] { 
    if ($generated_disko_config_path | is-empty) { error make { msg: "--generated_disko_config_path is required" } }
    if (not ($generated_disko_config_path | path exists)) { error make { msg: $"Generated disko config file not found: ($generated_disko_config_path)"}}
    
    print "Starting Disko application process..."
    let nix_config_repo_path = "/home/nixos/nix-config" # Standard path for the cloned repo, assumed to be ready

    let abs_generated_disko_config_path = ($generated_disko_config_path | path expand)

    print "Running disko..."
    # Note: Using --extra-experimental-features for newer Nix versions.
    ^sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode $mode $abs_generated_disko_config_path
    if $env.LAST_EXIT_CODE != 0 {
        error make { msg: "Disko execution failed." }
    }

    print "Creating user subvolumes..."
    let user_home_on_mnt = $"/mnt/home/($username)"
    ^sudo mkdir -p $user_home_on_mnt
    ^sudo chown $"($user_id):($group_id)" $user_home_on_mnt

    let subvolumes_to_create = [ "nix-config", "projects", "Documents", "Downloads", "games", "Maildir" ]
    for subvol in $subvolumes_to_create {
        let subvol_path = $"($user_home_on_mnt)/($subvol)"
        print $"Creating subvolume ($subvol_path)..."
        ^sudo btrfs subvolume create $subvol_path
        if $env.LAST_EXIT_CODE != 0 {
            print $"Warning: Failed to create subvolume ($subvol_path). It might already exist or another issue occurred."
        }
        ^sudo chown -R $"($user_id):($group_id)" $subvol_path
    }

    print $"Copying nix-config repository to ($user_home_on_mnt)/nix-config..."
    if not ($nix_config_repo_path | path exists) {
        error make { msg: $"Nix config repository not found at ($nix_config_repo_path). Ensure it was cloned and unlocked." }
    }
    ^sudo rsync -PamAXvtu $"($nix_config_repo_path)/" $"($user_home_on_mnt)/nix-config"
    if $env.LAST_EXIT_CODE != 0 {
        error make { msg: "Failed to rsync nix-config repository." }
    }

    print "Disk has been formatted and mounted at /mnt."
    print $"nix-config has been copied to ($user_home_on_mnt)/nix-config on the target system."
}

# Installs NixOS onto a system previously prepared.
export def install-nixos [
    session: string # The NixOS configuration session name from the flake (e.g., home_server). This parameter is required.
] {
    let nix_config_repo_path = "/home/nixos/nix-config" # Assumes this path exists and is unlocked.

    if not ($nix_config_repo_path | path exists) {
        error make { msg: $"Nix config directory ($nix_config_repo_path) not found. Run disko-install first or ensure it's cloned and unlocked." }
    }

    print $"Copying generated hardware-configuration.nix to ($nix_config_repo_path)/nixos/($session)/ ..."
    ^sudo nixos-generate-config --no-filesystems --root /mnt

    let hardware_config_source = "/mnt/etc/nixos/hardware-configuration.nix"
    let hardware_config_dest_dir = $"($nix_config_repo_path)/nixos/($session)"

    ^mkdir -p $hardware_config_dest_dir # Ensure destination directory exists. User 'nixos' should have write access.

    ^cp $hardware_config_source $"($hardware_config_dest_dir)/hardware-configuration.nix"

    let flake_uri = $"($nix_config_repo_path)#($session)"
    let trusted_substituters = [
        "https://weiss.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
        "https://cache.iog.io"
    ] | str join " "
    let trusted_public_keys = [
        "weiss.cachix.org-1:2IzFIzVwv8/iIrmz319mWB0KDqGl16eoNF67eX1YNdo="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "sylvorg.cachix.org-1:xd1jb7cDkzX+D+Wqt6TemzkJH9u9esXEFu1yaR9p8H8="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ] | str join " "

    ^sudo nixos-install --flake $flake_uri --option trusted-substituters $trusted_substituters --option trusted-public-keys $trusted_public_keys

    print "Installation complete! You can now reboot into your new system."
}
