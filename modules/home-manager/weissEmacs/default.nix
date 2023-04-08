{ pkgs, lib, config, ... }:
with lib;
let cfg = config.programs.weissEmacs;
in {
  options.programs.weissEmacs = rec {
    enable = mkEnableOption "weissEmacs";
    extraPackages = with types;
      mkOption {
        type = anything;
        default = lib.id;
      };
    arch = with types;
      mkOption {
        type = enum [ "linux" "mac" ];
        default = "linux";
      };
    user = with types;
      mkOption {
        type = str;
        default = "";
      };
    emacsConfigPath = with types; mkOption { type = path; };
    chaseSymLink = mkOption {
      type = with types;
        submodule {
          options = {
            enable = mkOption {
              type = bool;
              default = false;
            };
            absConfigDir = mkOption { type = str; };
          };
        };
    };
    userEmacsDirectory = with types; mkOption { type = str; };
    isConfigP = with types; mkOption { type = anything; };
    recipes = with types;
      mkOption {
        type = attrsOf anything;
        default = { };
      };
    emacsPkgs = with types;
      mkOption {
        type = listOf str;
        default = [ ];
        description = lib.mdDoc
          "packages need to be installed via straight. Special recipe rules need to be set in recipes. Note that all packages listed here are enabled.";
      };

    afterStartup = with types;
      mkOption {
        type = str;
        default = "(ignore)";
      };
    autoload = with types;
      mkOption {
        type = attrsOf (listOf str);
        default = { };
      };
    eagerLoad = with types;
      mkOption {
        type = listOf str;
        default = [ ];
        description = lib.mdDoc "local packages need to be enabled";
      };
    skipInstall = with types;
      mkOption {
        type = listOf str;
        default = [ ];
        description = lib.mdDoc "local packages need to be enabled";
      };
    earlyInit = with types;
      mkOption {
        type = str;
        default = "";
        description = lib.mdDoc "local packages need to be enabled";
      };
    extraConfig = with types;
      mkOption {
        type = anything;
        default = lib.id;
      };
    straightConfig = with types;
      mkOption {
        type = anything;
        default = lib.id;
      };
    localPkg = mkOption {
      description = "submodule example";
      type = with types;
        submodule {
          options = {
            enable = mkOption {
              type = bool;
              default = true;
            };
            dir = mkOption { type = path; };
            extraConfig = mkOption {
              type = anything;
              default = lib.id;
            };
          };
        };
    };
    startupOptimization = mkOption {
      description = "submodule example";
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

    localPkgCfg = if cfg.localPkg.enable then
      cfg.localPkg.extraConfig ''
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
      ''
    else
      "";
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
    nixEnvCfg = ''
      (setq emacs-host-list '("arch" "arch without roam" "ros" "mac"))
      (setq emacs-host (nth 0 emacs-host-list))
    '' + (if cfg.chaseSymLink.enable then ''
      (defvar weiss/configs-dir "${cfg.chaseSymLink.absConfigDir}/")
      (defun replace-nix-link (args)
        "replace nix link to the real config path"
        (cons
          (replace-regexp-in-string "^${cfg.emacsConfigPath}" "${cfg.chaseSymLink.absConfigDir}" (car args))
          (cdr args))
      )
      (advice-add 'find-file-noselect :filter-args #'replace-nix-link)
    '' else
      ''(defvar weiss/configs-dir "${cfg.emacsConfigPath}/")'');

    basicCfg = join [
      customCfg
      localPkgCfg
      autoloadCmds
      eagerLoadCmds
      nixEnvCfg
      configsCmds
      "(package-activate-all)"
      afterStartupCfg
    ];

  in mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      extraPackages = epkg:
        map (pkgName: lib.attrsets.getAttrFromPath [ pkgName ] epkg)
        (filter (pkg: !(elem pkg cfg.skipInstall)) cfg.emacsPkgs);
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
      };
    };

    home.file = {
      "${userEmacsDirectory}/early-init.el".text = cfg.earlyInit;
      "${userEmacsDirectory}/init.el".text = cfg.extraConfig basicCfg;
    };
  };
}

