{
  inputs,
  myLib,
  secrets,
  ...
}:

{
  inherit (inputs.niri.overlays) niri;

  yt-dlp-pkgs = import ./yt-dlp.nix;

  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: {
    additions = import ../pkgs {
      inherit myLib secrets;
      pkgs = final;
    };
  };

  emacs = import inputs.emacs-overlay;
  wired-notify = inputs.wired-notify.overlays.default;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications =
    final: prev:
    let
      master = import inputs.nixpkgs-master {
        system = final.system;
        config.allowUnfree = true;
      };
      # yt-dlp-pkgs = import ./yt-dlp.nix { inherit final prev; };
    in
    {
      # inherit (yt-dlp-pkgs) ytdl-sub-with-plugins;
      recentf = inputs.recentf.packages."${prev.system}".default;
      webman = inputs.webman.packages."${prev.system}";
      weissXmonad = inputs.weissXmonad.packages."${prev.system}".default;
      ripgrep-all = inputs.nixpkgs-lts.legacyPackages."${prev.system}".ripgrep-all;
      hledger-importer = inputs.hledger-importer.packages."${prev.system}".default;
      nix-alien = inputs.nix-alien.packages."${prev.system}".default;
      tdlib =
        (import (builtins.fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/611bf8f183e6360c2a215fa70dfd659943a9857f.tar.gz";
          sha256 = "sha256:1rhrajxywl1kaa3pfpadkpzv963nq2p4a2y4vjzq0wkba21inr9k";
        }) { inherit (prev) system; }).tdlib;
      yt-dlp = master.yt-dlp;
      # yt-dlp = yt-dlp-pkgs.ytdl-sub-with-plugins;
      aider-chat = master.aider-chat;
      # bison =
      #   (import (builtins.fetchGit {
      #     # Descriptive name to make the store path easier to identify
      #     name = "bison-revision";
      #     url = "https://github.com/NixOS/nixpkgs/";
      #     ref = "refs/heads/nixpkgs-unstable";
      #     rev = "407f8825b321617a38b86a4d9be11fd76d513da2";
      #   }) { inherit (prev) system; }).bison;
      # ytdl-sub-with-plugins =yt-dlp-pkgs
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # });
    };

  pinnedUnstables = final: prev: {
    pinnedUnstables = {
      "2023-03-31" =
        import
          (final.fetchFromGitHub {
            owner = "NixOS";
            repo = "nixpkgs";
            rev = "1b7a6a6e57661d7d4e0775658930059b77ce94a4";
            sha256 = "sha256-TG6M7UlWem7g/CEYPoR3mOfNFxNeaSoAAFRi88H3YYo=";
          })
          {
            system = final.system;
            config.allowUnfree = true;
          };
      "2023-09-27" =
        import
          (final.fetchFromGitHub {
            owner = "NixOS";
            repo = "nixpkgs";
            rev = "4ab8a3de296914f3b631121e9ce3884f1d34e1e5";
            sha256 = "sha256-mQUik6XZea6ZcCkMpUieq1oxlEDE0vqTTRU9RStgtSQ=";
          })
          {
            system = final.system;
            config.allowUnfree = true;
          };
      "2024-01-05" =
        import
          (final.fetchFromGitHub {
            owner = "NixOS";
            repo = "nixpkgs";
            rev = "c4bf72c17b886880de00ec809d215f26b4e1e3f3";
            sha256 = "sha256-9gLeub0z77eLmAQkVdhNQuBzfOZ1jGLNZldO0ARWvK8=";
          })
          {
            system = final.system;
            config.allowUnfree = true;
          };
      "2024-09-08" =
        import
          (final.fetchFromGitHub {
            owner = "NixOS";
            repo = "nixpkgs";
            rev = "e29ea571a3f9f1f906b41cfcb7c9f955419ea15a";
            sha256 = "sha256-erk1S1nEVFSbrQs8UHvJYht76KUp1IdTpzRj+P+Xuww=";
          })
          {
            system = final.system;
            config.allowUnfree = true;
          };
      "2024-09-16" =
        import
          (final.fetchFromGitHub {
            owner = "NixOS";
            repo = "nixpkgs";
            rev = "d43d78b0b0fe6124c8ac77ee515cff54118cb0bf";
            sha256 = "sha256-UXnOFicV+GN2mBQF4P01WpVuWXoDP2FrcSRpWnA+T1Y=";
          })
          {
            system = final.system;
            config.allowUnfree = true;
          };
      "2024-10-11" =
        import
          (final.fetchFromGitHub {
            owner = "NixOS";
            repo = "nixpkgs";
            rev = "1a7ad9eabbb44da5063195ffa2f6bf2056902623";
            sha256 = "sha256-LzicIsOq7tgATdekv3wfOX9WWP25/NObw8zk840eCJ0=";
          })
          {
            system = final.system;
            config.allowUnfree = true;
          };
      "2025-02-06" =
        import
          (final.fetchFromGitHub {
            owner = "NixOS";
            repo = "nixpkgs";
            rev = "9472de43946f312ab6c82ea25c416217c025c3db";
            sha256 = "sha256-P6CUfI32vWOhNcOPoQQCdQihqEX8baa6SeMET/Ivimc=";
          })
          {
            system = final.system;
            config.allowUnfree = true;
          };
      "2025-04-20" =
        import
          (final.fetchFromGitHub {
            owner = "NixOS";
            repo = "nixpkgs";
            rev = "1ea3c1d9676c9214492e82464174094c2130e002";
            sha256 = "sha256-ebShVkxVcXnu9Upv8OFE0/4hl5Srae61hJsbGsj6Lmw=";
          })
          {
            system = final.system;
            config.allowUnfree = true;
          };
      "2025-06-22" =
        import
          (final.fetchFromGitHub {
            owner = "NixOS";
            repo = "nixpkgs";
            rev = "ee19f0a079baa7ac8243c612eacc6e80faa9658f";
            sha256 = "sha256-abeIUYk8GUaXXSjDq8AKdXA0ea/lOioXHDdwN4yyuyo=";
          })
          {
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
