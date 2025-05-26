# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.

{
  # List your module files here
  v2ray = import ./v2ray.nix;
  xmonadBin = import ./xmonadBin.nix;
  private-gpt = import ./private-gpt.nix;
  myStash = import ./stash.nix;
}
