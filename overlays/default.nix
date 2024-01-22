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
  modifications = final: prev: {
    recentf = inputs.recentf.packages."${prev.system}".default;
    webman = inputs.webman.packages."${prev.system}";
    weissXmonad = inputs.weissXmonad.packages."${prev.system}".default;
    ripgrep-all =
      inputs.nixpkgs-lts.legacyPackages."${prev.system}".ripgrep-all;
    # tdlib = tdlib180.tdlib;
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  pinnedUnstables = final: prev: {
    pinnedUnstables = {
      "2023-09-27" = import (final.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "4ab8a3de296914f3b631121e9ce3884f1d34e1e5";
        sha256 = "sha256-mQUik6XZea6ZcCkMpUieq1oxlEDE0vqTTRU9RStgtSQ=";
      }) {
        system = final.system;
        config.allowUnfree = true;
      };
    };
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
