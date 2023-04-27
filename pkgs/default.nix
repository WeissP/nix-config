# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  mpv-bookmarker = pkgs.callPackage ./mpv-bookmarker.nix { };
  mpv-thumbfast = pkgs.callPackage ./mpv-thumbfast.nix { };
}
