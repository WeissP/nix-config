# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.

{
  recentf = import ./recentf.nix;
  webman = import ./webman.nix;
  setup = import ./setup.nix;
  weissEmacs = import ./weissEmacs;
  ytdlSub = import ./ytdl-sub.nix;
}
