# This file defines overlays
{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: { additions = import ../pkgs { pkgs = final; }; };
  weissNur = final: prev: {
    weissNur = inputs.weissNur.packages."${prev.system}";
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev:
    let
      tdlib180 = import (builtins.fetchGit {
        name = "tdlib1.8.0";
        url = "https://github.com/NixOS/nixpkgs/";
        ref = "refs/heads/nixos-22.05";
        rev = "2ca1e9e4aa4849e3310687fe6a2131d80258e777";
      }) {
        system = final.system;
        config.allowUnfree = true;
      };
    in {
      recentf = inputs.recentf.packages."${prev.system}".default;
      webman = inputs.webman.packages."${prev.system}";
      # tdlib = tdlib180.tdlib;
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # });
    };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  lts = final: _prev: {
    lts = import inputs.nixpkgs-lts {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
