{ pkgs, lib, myLib, secrets, myEnv, config, ... }:
with lib;
with myEnv;
let cfg = config.programs.weissEmacs;
in {
  options.programs.weissEmacs = rec {
    enable = mkEnableOption "weissEmacs";
    package = mkOption {
      type = types.package;
      default = pkgs.emacs;
      defaultText = literalExpression "pkgs.emacs";
      example = literalExpression "pkgs.emacs25-nox";
      description = "The Emacs package to use.";
    };
    rimeIntegration = mkOption {
      description = "TODO Whether to enable rime integration";
      default = { enable = false; };
      type = types.submodule {
        options = {
          enable = mkEnableOption "rime integration";
          package = mkOption { type = types.package; };
        };
      };
    };
    # mindwaveIntegration = mkOption {
    #   description = "TODO Whether to enable rime integration";
    #   default = { enable = false; };
    #   type = types.submodule {
    #     options = { enable = mkEnableOption "mindwave integration"; };
    #   };
    # };
    telegaIntegration = mkOption {
      description = "TODO Whether to enable rime integration";
      default = { enable = false; };
      type = types.submodule {
        options = {
          enable = mkEnableOption "telega integration";
          package = mkOption { type = types.package; };
        };
      };
    };
    userEmacsDirectory = with types;
      mkOption {
        description = "absolute path to emacs root config dir";
        type = str;
      };
    emacsConfigPath = with types;
      mkOption {
        description = "nix path to emacs config files dir";
        type = path;
      };
    isConfigP = with types;
      mkOption {
        description =
          "a function that receives a package name and returns a predicate function to filter pkg related config files located in `emacsConfigPath`";
        type = anything;
        example = pkg: lib.strings.hasPrefix "weiss_${pkg}_";
      };
    chaseSymLink = mkOption {
      description =
        "replace nix link to the real config path when open configs in emacs";
      default = { enable = false; };
      type = with types;
        submodule {
          options = {
            enable = mkOption {
              type = bool;
              default = false;
            };
            absConfigDir = mkOption {
              description = "absolute path to emacs config files dir";
              type = str;
            };
          };
        };
    };
    emacsPkgs = with types;
      mkOption {
        type = listOf str;
        default = [ ];
        description = "emacs packages";
      };

    afterStartup = with types;
      mkOption {
        type = str;
        default = "(ignore)";
        description = "commands need to be invoked with emacs-startup-hook";
      };
    autoload = with types;
      mkOption {
        type = attrsOf (listOf str);
        default = { };
        description = lib.mdDoc
          "An attrset where keys are packages and values are a list of functions of the package that need to be autoloaded. Note that only pkgs of `emacsPkgs` are considered";
      };
    eagerLoad = with types;
      mkOption {
        type = listOf str;
        default = [ ];
        description = lib.mdDoc
          "packages need to be eager loaded. Note that only pkgs of `emacsPkgs` are considered";
      };
    idleLoad = with types;
      mkOption {
        description = "packages to load while idle";
        default = { enable = false; };
        type = submodule {
          options = {
            enable = mkEnableOption "Idle Load";
            idleSeconds = mkOption { type = int; };
            packages = mkOption { type = listOf str; };
          };
        };
      };

    skipInstall = with types;
      mkOption {
        type = listOf str;
        default = [ ];
        description = lib.mdDoc
          "packages that dont need to be installed by nix. Note that the package related config files are still loaded";
      };
    earlyInit = with types;
      mkOption {
        type = str;
        default = "";
        description = lib.mdDoc "config in early-init.el";
      };
    extraConfig = with types;
      mkOption {
        type = anything;
        default = lib.id;
        description =
          "a function to receive generated basic config and return new config";
      };
    localPkg = mkOption {
      description = "local package related config";
      default = { enable = false; };
      type = with types;
        submodule {
          options = {
            enable = mkOption {
              type = bool;
              default = true;
            };
            dir = mkOption {
              type = path;
              description = "local package config directory";
            };
            extraConfig = mkOption {
              type = anything;
              default = lib.id;
              description =
                "a function to receive generated basic config and return new config";
            };
          };
        };
    };
    startupOptimization = mkOption {
      description = "submodule example";
      default = { enable = true; };
      type = with types;
        submodule {
          options = {
            enable = mkOption {
              type = bool;
              default = true;
            };
          };
        };
    };

  };
  config = let
    optionalString = cond: text: if cond then text else "";
    optionalList = cond: list: if cond then list else [ ];

    userEmacsDirectory = cfg.userEmacsDirectory;
    filterPkg = builtins.filter (e: builtins.elem e cfg.emacsPkgs);
    join = list: lib.strings.concatLines (filter isString (flatten list));
    getConfigs = pkg:
      filter (cfg.isConfigP pkg)
      (builtins.attrNames (builtins.readDir cfg.emacsConfigPath));

    configsCmds = map (pkg: ''(load "${cfg.emacsConfigPath}/${pkg}" nil t)'')
      (flatten (map getConfigs cfg.emacsPkgs));
    autoloadCmds = lib.attrsets.mapAttrsToList (pkg: funs:
      if builtins.elem pkg cfg.emacsPkgs then
        (map (fn: ''(autoload '${fn} "${pkg}")'') funs)
      else
        [ ]) cfg.autoload;
    eagerLoadCmds = map (pkg: "(require '${pkg})") (filterPkg cfg.eagerLoad);
    idleLoadCmds = [
      "(require 'idle-require)"
      "(setq idle-require-idle-delay ${toString cfg.idleLoad.idleSeconds})"
      (map (pkg: "(idle-require '${pkg})") cfg.idleLoad.packages)
      "(idle-require-mode 1)"
    ];
    localPkgCfg = cfg.localPkg.extraConfig ''
      (setq weiss/local-package-path  "${userEmacsDirectory}/local-packages")
      (setq weiss/local-package-autoloads "${userEmacsDirectory}/local-package-loaddefs.el")
      (defun weiss-update-local-packages-autoloads ()
        "update autoloads of local packages"
        (interactive)
        (dolist (dir (seq-filter
                      'file-directory-p
                      (directory-files weiss/local-package-path t "^[^.]") ;ignore /. and /..
        )) 
          (make-directory-autoloads dir weiss/local-package-autoloads)
        )
      )

      (unless (file-exists-p weiss/local-package-autoloads)
        (message "autoloads of local packages do not exist, generating...")
        (weiss-update-local-packages-autoloads)
      )
      (load weiss/local-package-autoloads)
      (let ((default-directory weiss/local-package-path))
        (normal-top-level-add-subdirs-to-load-path))
    '';
    customCfg = ''
      (setq custom-file "${userEmacsDirectory}/custom.el")
      (when (file-exists-p custom-file)
        (load custom-file))
    '';
    afterStartupCfg = ''
      (add-hook 'emacs-startup-hook
          (lambda ()
            ${cfg.afterStartup}
          ))
    '';
    telegaIntegrationCfg = ''
      (setq telega-server-command "${cfg.telegaIntegration.package.outPath}/bin/telega-server") '';
    rimeIntegrationCfg = (if arch == "linux" then ''
      (setq rime--module-path "${cfg.rimeIntegration.package.outPath}/include/librime-emacs.so")
    '' else ''
      (setq rime-emacs-module-header-root "${cfg.package.outPath}/include")
      (setq rime-librime-root "${cfg.userEmacsDirectory}/librime/dist")
      (setq rime-share-data-dir "${homeDir}/Library/Rime/")
    '');
    mindwaveIntegrationCfg = ''
      (setq mind-wave-python-command "nix-shell")
      (setq mind-wave-python-file "${userEmacsDirectory}/local-packages/mind-wave/mind_wave.py")
    '';
    chaseSymLinkCfg = ''
      (setq weiss/configs-dir "${cfg.chaseSymLink.absConfigDir}/")
      (defun replace-nix-link (args)
        "replace nix link to the real config path"
        (cons
          (replace-regexp-in-string "^${cfg.emacsConfigPath}" "${cfg.chaseSymLink.absConfigDir}" (car args))
          (cdr args))
      )
      (advice-add 'find-file-noselect :filter-args #'replace-nix-link)
    '';
    nixEnvCfg = ''(defvar weiss/configs-dir "${cfg.emacsConfigPath}/")'';

    basicCfg = join [
      customCfg
      (optionalList cfg.localPkg.enable localPkgCfg)
      autoloadCmds
      eagerLoadCmds
      (optionalList cfg.idleLoad.enable [ idleLoadCmds ])
      nixEnvCfg
      (optionalList cfg.telegaIntegration.enable [ telegaIntegrationCfg ])
      (optionalList cfg.rimeIntegration.enable [ rimeIntegrationCfg ])
      # (optionalList cfg.mindwaveIntegration.enable [ mindwaveIntegrationCfg ])
      (optionalList cfg.chaseSymLink.enable [ chaseSymLinkCfg ])
      configsCmds
      "(package-activate-all)"
      afterStartupCfg
    ];

  in mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      overrides = prev: final: {
        org-table-to-qmk-keymap =
          pkgs.callPackage ./packages/org-table-to-qmk-keymap {
            inherit (final) trivialBuild;
          };
        dired-single-handed-mode =
          pkgs.callPackage ./packages/dired-single-handed-mode {
            inherit (final) trivialBuild dired-filter hydra;
          };
        weiss-org-sp = pkgs.callPackage ./packages/weiss-org-sp {
          inherit (final) trivialBuild;
        };
        weiss-tsc-mode = pkgs.callPackage ./packages/weiss-tsc-mode {
          inherit (final) trivialBuild dash tree-sitter tree-sitter-langs s;
        };
        rotate-text = pkgs.callPackage ./packages/rotate-text.nix {
          inherit (final) trivialBuild;
          inherit (pkgs) fetchFromGitHub;
        };
        mind-wave =
          pkgs.callPackage ./packages/mind-wave { inherit (final) melpaBuild; };
      };
      # rime and telega can only be installed via xxxIntegration option
      extraPackages = epkg:
        map (pkgName: lib.attrsets.getAttrFromPath [ pkgName ] epkg)
        ((filter (pkg: !(elem pkg (cfg.skipInstall ++ [ "rime" "telega" ])))
          cfg.emacsPkgs)
          ++ (optionalList (cfg.rimeIntegration.enable && arch == "linux")
            [ "rime" ]) # rime will be installed locally on MacOS
          # ++ (optionalList cfg.telegaIntegration.enable [ "mind-wave" ])
          ++ (optionalList cfg.telegaIntegration.enable [ "telega" ])
          ++ (optionalList cfg.idleLoad.enable [ "idle-require" ]));
    };

    home = {
      file = mkMerge [
        {
          "${userEmacsDirectory}/early-init.el".text = cfg.earlyInit;
          "${userEmacsDirectory}/init.el".text = cfg.extraConfig basicCfg;
        }
        (lib.optionalAttrs cfg.localPkg.enable {
          "${userEmacsDirectory}/local-packages" = {
            source = cfg.localPkg.dir;
            recursive = true;
          };
        })
        (optionalAttrs (arch == "darwin" && cfg.rimeIntegration.enable) {
          "${userEmacsDirectory}/local-packages/emacs-rime" = {
            source = pkgs.fetchFromGitHub {
              owner = "DogLooksGood";
              repo = "emacs-rime";
              rev = version;
              hash = "sha256-Z4hGsXwWDXZie/8IALhyoH/eOVfzhbL69OiJlLHmEXw=";
            };
            recursive = true;
          };
          "${userEmacsDirectory}/librime" = {
            source = pkgs.fetchzip {
              url =
                "https://github.com/rime/librime/releases/download/1.8.4/rime-a94739f-macOS.tar.bz2";
              sha256 = "sha256-rxkbiTIC8+i8Zr66lfj6JDFOf4ju8lo3dPP1UDIPC1c=";
              stripRoot = false;
            };
            recursive = true;
          };
        })
      ];
      packages = [ ]
        ++ (optionalList (cfg.rimeIntegration.enable && arch == "linux")
          [ cfg.rimeIntegration.package ])
        ++ (optionalList cfg.telegaIntegration.enable
          [ cfg.telegaIntegration.package ]);
      sessionVariables = { EDITOR = "emacsclient --create-frame"; };
    };
  };
}

