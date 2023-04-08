{ pkgs ? import <nixpkgs> { } , ...}:
# let
  # pkgs = import <nixpkgs> { }; # pin the channel to ensure reproducibility!
# in
pkgs.haskellPackages.developPackage {
  root = ./.;
  # source-overrides = {
  #   mylibrary = ./mylibrary;
  # };
}
