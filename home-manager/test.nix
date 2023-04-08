# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, username, ... }: {
  # You can import other home-manager modules here
  imports = [
    ./common/common.nix
    ./common/emacs
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];
  home.packages = with pkgs; [ uxplay calibre ocamlPackages.cpdf ];
}
