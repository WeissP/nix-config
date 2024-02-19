{ pkgs, lib, myLib, secrets, myEnv, config, ... }:
with lib;
with myEnv;
let cfg = config.programs.weissEmacs;
in {
  options.programs.weissEmacs = let
    recipe = with types;
      submodule {
        options = {
          emacsPackages = mkOption {
            type = listOf str;
            default = [ ];
          };
          externalPackages = mkOption {
            type = listOf package;
            default = [ ];
          };
          cmds = mkOption {
            type = str;
            default = "";
          };
          localPackages = mkOption {
            type = attrsOf path;
            default = { };
          };
          files = mkOption {
            type = attrsOf anything;
            default = { };
          };
        };
      };
  in rec {
    enable = mkEnableOption "weissEmacs";
    package = mkOption {
      type = types.package;
      default = pkgs.emacs;
      defaultText = literalExpression "pkgs.emacs";
      example = literalExpression "pkgs.emacs25-nox";
      description = "The Emacs package to use.";
    };
    userEmacsDirectory = with types;
      mkOption {
        description = "absolute path to emacs root config dir";
        type = str;
      };
    localPkgPath = with types;
      mkOption {
        description = "absolute path local Pkg";
        default = "${cfg.userEmacsDirectory}/local-packages";
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
    recipes = mkOption {
      description = "recipes";
      default = {
        lsp-bridge = {
          files."${cfg.userEmacsDirectory}/lsp-bridge" = {
            source = pkgs.fetchFromGitHub {
              owner = "manateelazycat";
              repo = "lsp-bridge";
              rev = "a3f0c1d468b8485b09ac94e11279b8436ac6e415";
              sha256 = "sha256-3SzxTa2DsXYFwoqqZQjgmxwM8WbmL48Fhm6QDrmmINU=";
            };
            # recursive = true;
          };
          # externalPackages = [
          #   (pkgs.python3.withPackages (ps:
          #     with ps; [
          #       epc
          #       orjson
          #       sexpdata
          #       six
          #       setuptools
          #       paramiko
          #       rapidfuzz
          #     ]))
          # ];
          cmds =
            ''(add-to-list 'load-path "${cfg.userEmacsDirectory}/lsp-bridge")'';
        };
        cape = {
          emacsPackages = [ "cape" ];
          cmds = let wordList = myLib.resource "filtered_word_list.txt";
          in ''
            (setq cape-dict-file "${wordList}")
          '';
        };
        flyspell = {
          emacsPackages = [ "flymake" ];
          externalPackages = with pkgs; [ (aspellWithDicts (d: [ d.en ])) ];
          # files.".aspell.conf".text = "data-dir ${pkgs.aspell}/lib/aspell";
        };
        magit-delta = {
          emacsPackages = [ "magit-delta" ];
          externalPackages = [ pkgs.delta ];
        };
        jinx = let myAspell = pkgs.aspellWithDicts (d: [ d.en d.de ]);
        in {
          emacsPackages = [ "jinx" ];
          externalPackages = with pkgs; [ myAspell ];
          files.".aspell.conf".text = "dict-dir ${myAspell}/lib/aspell";
        };
        flymake-sqlfluff = {
          emacsPackages = [ "flymake-sqlfluff" ];
          externalPackages = [ pkgs.lts.sqlfluff ];
        };
        ejc-sql = {
          emacsPackages = [ "ejc-sql" ];
          externalPackages = [ pkgs.leiningen ];
        };
        ess = {
          emacsPackages = [ "ess" ];
          externalPackages = [ pkgs.R ];
        };
        lua-mode = {
          emacsPackages = [ "lua-mode" ];
          externalPackages = [ pkgs.stylua ];
        };
        rime = if arch == "linux" then
          let pkg = pkgs.weissNur.emacs-rime;
          in {
            emacsPackages = [ "rime" ];
            externalPackages = [ pkg ];
            cmds = ''
              (setq rime--module-path "${pkg.outPath}/include/librime-emacs.so")
              (setq rime-share-data-dir "${homeDir}/.local/share/fcitx5/rime/")
            '';
          }
        else {
          cmds = ''
            (setq rime-emacs-module-header-root "${cfg.package.outPath}/include")
            (setq rime-librime-root "${cfg.userEmacsDirectory}/librime/dist")
            (setq rime-share-data-dir "${homeDir}/Library/Rime/")
          '';
          localPackages."emacs-rime" = pkgs.fetchFromGitHub {
            owner = "DogLooksGood";
            repo = "emacs-rime";
            rev = version;
            hash = "sha256-Z4hGsXwWDXZie/8IALhyoH/eOVfzhbL69OiJlLHmEXw=";
          };
          files."${cfg.userEmacsDirectory}/librime" = {
            source = pkgs.fetchzip {
              url =
                "https://github.com/rime/librime/releases/download/1.8.4/rime-a94739f-macOS.tar.bz2";
              sha256 = "sha256-rxkbiTIC8+i8Zr66lfj6JDFOf4ju8lo3dPP1UDIPC1c=";
              stripRoot = false;
            };
            recursive = true;
          };
        };
        telega = let pkg = pkgs.weissNur.telega-server;
        in {
          cmds =
            ''(setq telega-server-command "${pkg.outPath}/bin/telega-server")'';
          externalPackages = [ pkg pkgs.ffmpeg ];
          emacsPackages = [ "telega" ];
        };
        mind-wave =
          let apiPath = "${cfg.localPkgPath}/mind-wave/schluessel.txt";
          in {
            cmds = ''
              (setq mind-wave-python-command "nix-shell")
              (setq mind-wave-api-key-path "${apiPath}")
            '';
            files."${apiPath}".text = secrets.openai.apiKey;
            localPackages."mind-wave" = pkgs.fetchFromGitHub {
              owner = "manateelazycat";
              repo = "mind-wave";
              rev = "b787803ff745dde28727c10833b397d846fc1f7f";
              sha256 = "sha256-sqMeMdLZyU26BSrDrHw+leM9aD6a9jqtzwPcWQ4RYF8=";
              postFetch = ''
                pushd $out 
                ${pkgs.git.outPath}/bin/git apply ${
                  ./patches + "/mind-wave.patch"
                }
                popd
              '';
            };
          };
        maxima = {
          localPackages."maxima" = pkgs.fetchFromGitLab {
            owner = "sasanidas";
            repo = "maxima";
            rev = "1913ee496bb09430e85f76dfadf8ba4d4f95420f";
            hash = "sha256-PSZlcv48h6ML/HXneH/kZ7gfA3fEwptsI/elCyjGNNY";
          };
          externalPackages = with pkgs; [ maxima ghostscript gnuplot ];
        };
        nerd-icons-dired = {
          localPackages."nerd-icons-dired" = pkgs.fetchFromGitHub {
            owner = "rainstormstudio";
            repo = "nerd-icons-dired";
            rev = "4a068884bf86647d242c3adc8320cd603e15dac3";
            hash = "sha256-TkdEQDkwQDzkIIBUX7If+PYg78zwfNUB/RpYuIHqydo=";
          };
        };
        citre = {
          externalPackages = [ pkgs.universal-ctags ];
          emacsPackages = [ "citre" ];
        };
      };
      type = types.attrsOf recipe;
    };
  };
  config = let
    optionalList = cond: list: if cond then list else [ ];

    userEmacsDirectory = cfg.userEmacsDirectory;
    localPkgPath = "${userEmacsDirectory}/local-packages";
    join = list: lib.strings.concatLines (filter isString (flatten list));
    getConfigs = pkg:
      filter (cfg.isConfigP pkg)
      (builtins.attrNames (builtins.readDir cfg.emacsConfigPath));

    handleRime = (if arch == "linux" then
      let pkg = pkgs.weissNur.emacs-rime;
      in {
        emacsPackages = [ "rime" ];
        externalPackages = [ pkg ];
        cmds = ''
          (setq rime--module-path "${pkg.outPath}/include/librime-emacs.so")
          (setq rime-share-data-dir "${homeDir}/.local/share/fcitx5/rime/")
        '';
      }
    else {
      cmds = ''
        (setq rime-emacs-module-header-root "${cfg.package.outPath}/include")
        (setq rime-librime-root "${userEmacsDirectory}/librime/dist")
        (setq rime-share-data-dir "${homeDir}/Library/Rime/")
      '';
      localPackages."emacs-rime" = pkgs.fetchFromGitHub {
        owner = "DogLooksGood";
        repo = "emacs-rime";
        rev = version;
        hash = "sha256-Z4hGsXwWDXZie/8IALhyoH/eOVfzhbL69OiJlLHmEXw=";
      };
      files."${userEmacsDirectory}/librime" = {
        source = pkgs.fetchzip {
          url =
            "https://github.com/rime/librime/releases/download/1.8.4/rime-a94739f-macOS.tar.bz2";
          sha256 = "sha256-rxkbiTIC8+i8Zr66lfj6JDFOf4ju8lo3dPP1UDIPC1c=";
          stripRoot = false;
        };
        recursive = true;
      };
    });
    handleTelega = let pkg = pkgs.weissNur.telega-server;
    in {
      cmds =
        ''(setq telega-server-command "${pkg.outPath}/bin/telega-server")'';
      externalPackages = [ pkg pkgs.ffmpeg ];
      emacsPackages = [ "telega" ];
    };
    handleMindWave = let apiPath = "${localPkgPath}/mind-wave/schluessel.txt";
    in {
      cmds = ''
        (setq mind-wave-python-command "nix-shell")
        (setq mind-wave-api-key-path "${apiPath}")
      '';
      files."${apiPath}".text = secrets.openai.apiKey;
      localPackages."mind-wave" = pkgs.fetchFromGitHub {
        owner = "manateelazycat";
        repo = "mind-wave";
        rev = "075e5b0c11c8a3f670d2c8ef8dc4e66c6084b958";
        sha256 = "sha256-avwFsfrbOPWcT/ZLdRVhf8fK3/yUX1S36d4QPqq6meA=";
        postFetch = ''
          sed -i -e '1s:^#!/usr/bin/env python3:#! /usr/bin/env nix-shell:' -e '1a #! nix-shell -i python3 -p python3Packages.openai python3Packages.epc python3Packages.sexpdata python3Packages.six' "$out/mind_wave.py"
        '';
      };
    };
    handleMaxima = {
      localPackages."maxima" = pkgs.fetchFromGitLab {
        owner = "sasanidas";
        repo = "maxima";
        rev = "1913ee496bb09430e85f76dfadf8ba4d4f95420f";
        hash = "sha256-PSZlcv48h6ML/HXneH/kZ7gfA3fEwptsI/elCyjGNNY";
      };
      externalPackages = with pkgs; [ maxima ghostscript gnuplot ];
    };

    handleEglotJava = {
      emacsPackages = [ "eglot-java" ];
      extraPackages = [ pkgs.jdt-language-server ];
    };

    handleLocalPackages = pkg: {
      localPackages."${pkg}" = ./local-packages + "/${pkg}";
    };
    recipes = map (pkgName:
      if (builtins.hasAttr pkgName cfg.recipes) then
      # { }
        cfg.recipes."${pkgName}"
        # lib.attrsets.getAttrFromPath [ pkgName ] cfg.recipes
        # if pkgName == "rime" then
        #   handleRime
        # else if pkgName == "telega" then
        #   handleTelega
        # else if pkgName == "mind-wave" then
        #   handleMindWave
        # else if pkgName == "maxima" then
        #   handleMaxima
        # else if pkgName == "eglot-java" then
        # handleEglotJava
      else if (builtins.elem pkgName [
        "snails"
        "snails-custom-backends"
        "snails-roam"
        "chinese-yasdcv"
        "org-edit-latex"
      ]) then
        handleLocalPackages pkgName
      else {
        emacsPackages =
          optionalList (!builtins.elem pkgName cfg.skipInstall) [ pkgName ];
      }) cfg.emacsPkgs;

    localPkgs = lib.flatten (map (lib.attrsets.mapAttrsToList (k: v: {
      name = k;
      value = v;
    })) (lib.attrsets.catAttrs "localPackages" recipes));
    files = lib.flatten (map (lib.attrsets.mapAttrsToList (k: v: {
      name = k;
      value = v;
    })) (lib.attrsets.catAttrs "files" recipes));
    emacsPackages = flatten (lib.attrsets.catAttrs "emacsPackages" recipes);
    externalPackages =
      flatten (lib.attrsets.catAttrs "externalPackages" recipes);
    recipeCmds = (lib.attrsets.catAttrs "cmds" recipes) ++ (map (localPkg: ''
      (add-to-list 'load-path "${localPkgPath}/${localPkg}")
    '') (lib.attrsets.catAttrs "name" localPkgs));
    filterPkg = builtins.filter (e: builtins.elem e cfg.emacsPkgs);

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
      (map (pkg: "(idle-require '${pkg})") (filterPkg cfg.idleLoad.packages))
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
    # telegaIntegrationCfg = ''
    #   (setq telega-server-command "${cfg.telegaIntegration.package.outPath}/bin/telega-server") '';
    # rimeIntegrationCfg = (if arch == "linux" then ''
    #   (setq rime--module-path "${cfg.rimeIntegration.package.outPath}/include/librime-emacs.so")
    # '' else ''
    #   (setq rime-emacs-module-header-root "${cfg.package.outPath}/include")
    #   (setq rime-librime-root "${cfg.userEmacsDirectory}/librime/dist")
    #   (setq rime-share-data-dir "${homeDir}/Library/Rime/")
    # '');
    # mindwaveIntegrationCfg = ''
    #   (setq mind-wave-python-command "nix-shell")
    #   (add-to-list 'load-path "${cfg.userEmacsDirectory}/mind-wave/")
    # '';
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
      # (optionalList cfg.localPkg.enable localPkgCfg)
      autoloadCmds
      (optionalList cfg.idleLoad.enable [ idleLoadCmds ])
      nixEnvCfg
      recipeCmds
      # (optionalList cfg.telegaIntegration.enable [ telegaIntegrationCfg ])
      # (optionalList cfg.rimeIntegration.enable [ rimeIntegrationCfg ])
      # (optionalList cfg.mindwaveIntegration.enable [ mindwaveIntegrationCfg ])
      (optionalList cfg.chaseSymLink.enable [ chaseSymLinkCfg ])
      configsCmds
      eagerLoadCmds
      "(package-activate-all)"
      afterStartupCfg
    ];

  in mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = cfg.package;
      overrides = prev: final: {
        # acm = pkgs.callPackage ./packages/acm {
        # };
        # lsp-bridge = pkgs.callPackage ./packages/lsp-bridge {
        # };
        denote = pkgs.callPackage ./packages/denote-git.nix {
          inherit (final) trivialBuild;
          inherit (pkgs) fetchFromGitHub;
        };
        consult-tramp = pkgs.callPackage ./packages/consult-tramp.nix {
          inherit (final) trivialBuild consult;
          inherit (pkgs) fetchFromGitHub;
        };
        org-table-to-qmk-keymap =
          pkgs.callPackage ./packages/org-table-to-qmk-keymap {
            inherit (final) trivialBuild;
          };
        dired-single-handed-mode =
          pkgs.callPackage ./packages/dired-single-handed-mode {
            inherit (final) trivialBuild dired-filter hydra modus-themes;
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
        tla-tools = pkgs.callPackage ./packages/tla-tools.nix {
          inherit (final) trivialBuild polymode;
          inherit (pkgs) fetchFromGitHub;
        };
        ammonite-term-repl = pkgs.callPackage ./packages/ammonite-term-repl {
          inherit (final) trivialBuild scala-mode s;
        };
        ob-ammonite = pkgs.callPackage ./packages/ob-ammonite {
          inherit (final) trivialBuild s scala-mode xterm-color;
        };
        scala-cli-repl = pkgs.callPackage ./packages/scala-cli-repl.nix {
          inherit (final) trivialBuild scala-mode s xterm-color;
          inherit (pkgs) fetchFromGitHub;
        };
      };
      extraPackages = epkg:
        map (pkgName: lib.attrsets.getAttrFromPath [ pkgName ] epkg)
        (emacsPackages
          ++ (optionalList cfg.idleLoad.enable [ "idle-require" ]));
    };

    home = {
      file = (builtins.listToAttrs files) // (builtins.listToAttrs (map (o: {
        name = "${localPkgPath}/${o.name}";
        value = {
          source = o.value;
          recursive = true;
        };
      }) localPkgs)) // {
        "${userEmacsDirectory}/early-init.el".text = cfg.earlyInit;
        "${userEmacsDirectory}/init.el".text = cfg.extraConfig basicCfg;
      };
      packages = externalPackages;
      sessionVariables = { EDITOR = "emacsclient --create-frame"; };
    };
  };
}

