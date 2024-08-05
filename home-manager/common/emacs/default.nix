{ inputs, outputs, lib, myEnv, config, secrets, pkgs, ... }:
with myEnv;
let userEmacsDirectory = "${homeDir}/.emacs.d";
in {
  imports = [ outputs.homeManagerModules.weissEmacs ../recentf.nix ];

  home.packages = with pkgs; [ clj-kondo nodePackages.jsonlint nixfmt ];
  programs.weissEmacs = lib.mkMerge [
    (ifDarwin {
      package = pkgs.emacs29-pgtk.override { withXwidgets = false; };
    })
    (ifLinux { package = pkgs.emacs29; })
    {
      inherit userEmacsDirectory;
      enable = true;
      emacsConfigPath = ./configs;
      chaseSymLink = {
        enable = true;
        absConfigDir = "${nixDir}/home-manager/common/emacs/configs";
      };
      isConfigP = pkg: lib.strings.hasPrefix "weiss_${pkg}_";
      earlyInit = ''
        (setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
              gc-cons-percentage 0.6)
        ;; Inhibit resizing frame
        (setq frame-inhibit-implied-resize t)

        ;; Faster to disable these here (before they've been initialized)
        (push '(menu-bar-lines . 0) default-frame-alist)
        (push '(tool-bar-lines . 0) default-frame-alist)
        (push '(vertical-scroll-bars) default-frame-alist)
        (when (featurep 'ns)
          (push '(ns-transparent-titlebar . t) default-frame-alist))
        (setq-default mode-line-format nil)
        (setq package-enable-at-startup nil)
      '';
      afterStartup = ''
        (message "*** Emacs loaded in %s with %d garbage collections."
          (format "%.2f seconds"
                  (float-time
                   (time-subtract after-init-time before-init-time))) gcs-done)
        (setq insert-directory-program "${pkgs.coreutils}/bin/ls")
        (setq gc-cons-threshold (* (expt 1024 3) 6)
              gc-cons-percentage 0.5
              garbage-collection-messages nil)
      '';
      extraConfig = oldCfg: ''
        (setq mac-right-option-modifier nil)
        (setq vanilla-global-map (current-global-map))
        (setq recentf-executable "${pkgs.recentf.outPath}/bin/recentf")
        (setq mathpix-api-id "${secrets.mathpix.apiID}")
        (setq mathpix-api-key "${secrets.mathpix.apiKey}")

        ${oldCfg}
      '';

      localPkg = {
        enable = true;
        dir = ./local-packages;
      };
      autoload = {
        s = [ "s-replace" "s-chop-left" "s-starts-with?" ];
        dired-quick-sort = [ "hydra-dired-quick-sort/body" ];
        puni = [ "puni-strict-forward-sexp" "puni-strict-backward-sexp" ];
        pdf-view = [ "pdf-view-mode" ];
        dired-single-handed-mode = [ "weiss-dired-single-handed-mode" ];
        rotate-text = [ "rotate-text" ];
        weiss-tsc-mode = [ "weiss-tsc-mode" ];
        org-edit-latex = [ "org-edit-latex-mode" ];
        eglot-java = [ "eglot-java-mode" ];
        apheleia = [ "apheleia-global-mode" ];
        consult = [ "consult--multi" ];
        consult-tramp = [ "consult-tramp" ];
        citar-denote = [ "citar-denote-open-note" ];
        chatu = [ "chatu-mode" ];
      };
      eagerLoad = [
        "direnv"
        "mind-wave"
        "cl-lib"
        "mode-local"
        "snails"
        "server"
        "super-save"
        "weiss-org-sp"
        "vertico"
        "vertico-directory"
        "orderless"
        "marginalia"
        "popwin"
        "hl-line"
        "delight"
        "highlight-parentheses"
        "ligature"
        "gcmh"
        "tab-line"
        "nerd-icons"
        "diredfl"
        "nerd-icons-dired"
        "tla-tools"
        "separedit"
        "consult-notes"
        "jinx"
        "eldoc-box"
        # "highlight-defined"
        "darkman"
        "modus-themes"
        "circadian"
        "mustache-mode"
      ];
      idleLoad = {
        enable = true;
        idleSeconds = 3;
        packages = [
          "corfu"
          "cape"
          "kind-icon"
          "nerd-icons-corfu"
          "substitute"
          "denote"
          "embark"
          "eglot"
          "flyspell-correct"
          "org"
          "citar"
          "citar-denote"
          # "org-roam"
          "pdf-view"
          "pdf-view-restore"
          "ledger-mode"
          "apheleia"
          "string-inflection"
        ];
      };
      skipInstall = [
        "mathpix"
        "python"
        "tramp"
        "server"
        "wks"
        "global"
        "email"
        "dired"
        "abbrevs"
        "modeline"
        "flymake"
        "flyspell"
        "ui"
        "cl-lib"
        "mode-local"
        # "rotate-text"
        "mhtml-mode"
        "vertico-directory"
        "sql"
        "pdf-view"
        "org-cite"
        "gud"
        "elec-pair"
        "aweshell"
        "tab-line"
        # "snails-roam"
        "wdired"
        "hl-line"
        "whitespace"
        "display-line-numbers"
        "snails"
        "snails-custom-backends"
        "recentf-db"
        "recentf"
        "latex"
        "dabbrev"
        # "weiss-tsc-mode"
        # "weiss-dired-single-handed-mode"
        # "weiss-org-sp"
      ];

      emacsPkgs = let
        libs = [ "s" "exec-path-from-shell" "hydra" "cl-lib" "mode-local" "f" ];
        core = [ "rotate-text" "global" "wks" ];
        edit = [ "puni" "apheleia" "abbrevs" "separedit" "elec-pair" ];
        completion = [
          # [ "company" "company-box" ]
          # [ "snails" "snails-custom-backends" ]
          "yasnippet"
          [ "vertico" "vertico-directory" ]
          "orderless"
          "marginalia"
          [ "consult" "consult-tramp" ]
          "dabbrev"
          [
            "corfu" # "kind-icon"
            "nerd-icons-corfu"
            "cape"
          ]
        ];
        lang = [
          [
            "scala-mode"
            "sbt-mode"
            "ammonite-term-repl"
            "ob-ammonite"
            "scala-cli-repl"
          ]
          "nushell-mode"
          [ "elixir-mode" "flymake-elixir" "inf-elixir" "ob-elixir" ]
          [ "clojure-mode" "cider" ]
          "typescript-mode"
          [ "python" "live-py-mode" ]
          "php-mode"
          [ "haskell-mode" ]
          "rustic"
          [
            "web-mode"
            "rjsx-mode"
            "mhtml-mode"
            "svelte-mode"
            [ "http" "auto-rename-tag" ]
          ]
          [ "go-mode" [ "go-gen-test" "gotest" "go-dlv" "go-impl" "go-eldoc" ] ]
          [
            "sql" # "ejc-sql"
            "sql-indent"

          ]
          [ "haskell-mode" "dante" ]
          "lua-mode"
          "nix-mode"
          [ "dotenv-mode" "yaml-mode" "json-mode" ]
          [ "csv-mode" "ledger-mode" "mustache-mode" "agda2-mode" ]
          "dockerfile-mode"
          "markdown-mode"
          "mustache-mode"
          "ess"
        ];
        pdf =
          [ "pdf-tools" "pdf-view" "pdf-view-restore" "literate-calc-mode" ];
        tools = [
          [ "embark" "embark-consult" "string-inflection" ]
          [ "chatu" "chatu-xournal" ]
          "ztree"
          "pueue"
          "rfc-mode"
          "mathpix"
          "direnv"
          "project"
          # "recentf-db"
          "recentf"
          "rg"
          "which-key"
          "super-save"
          "command-log-mode"
          "gud"
          "quickrun"
          [
            "eglot"
            # "eglot-booster"
            # "eglot-signature-eldoc-talkative"
          ]
          "lspce"
          # [ "lsp-bridge" "flymake-bridge" ]
          [ "magit" "forge" ]
          "browse-at-remote"
          "aweshell"
          "gcmh"
          "citre"
          "tab-line"
          "mind-wave"
          "polymode"
          "tla-tools"
          "use-proxy"
          "denote"
          [ "citar" "citar-denote" "biblio" ]
          "substitute"
          # "maxima"
          # [ "tree-sitter" "tree-sitter-langs" "weiss-tsc-mode" ]
        ];
        lint = [
          # [ "flyspell" "wucuo" "flyspell-correct" ]
          "jinx"
          "flymake"
          "flymake-kondor"
          "flymake-json"
        ];
        org = [
          "org"
          "org-clock-csv"
          # "org-xournalpp"
          "weiss-org-sp"
          "org-cite"
          [ "ob-go" "ob-sql-mode" ]
          "org-pdftools"
          "org-noter"
          # [ "org-roam" "snails-roam" ]
          [ "org-fancy-priorities" "org-appear" ]
          "org-table-to-qmk-keymap"
          "org-edit-latex"
        ];
        latex = [
          "latex"
          "auctex"
          "org-ref"
          "magic-latex-buffer"
          "latex-preview-pane"
        ];
        dired = [
          "dired"
          "wdired"
          [ "dired-rsync-transient" "dired-rsync" ]
          [ "diredfl" "nerd-icons-dired" ]
          [ "dired-filter" "dired-avfs" "dired-collapse" "dired-quick-sort" ]
          "dired-hacks-utils"
          "peep-dired"
          "dired-single-handed-mode"
        ];
        ui = [
          "ui"
          "valign"
          # "eldoc-box"
          # [ "sideline" ]
          [ "modeline" "delight" ]
          "popwin"
          [
            "modus-themes"
            "darkman" # "circadian"
          ]
          "rainbow-mode"
          "highlight-indent-guides"
          "highlight-defined"
          "highlight-parentheses"
          "highlight-symbol"
          "hl-line"
          "hl-todo"
          "emojify"
          "anzu"
          "web-beautify"
          "whitespace"
          "ligature"
          # "all-the-icons"
          "nerd-icons"
          "display-line-numbers"
          "svg-tag-mode"
        ];
        email = [ "email" "notmuch" ];
        tramp = [ "tramp" "sudo-edit" ];
        translate = [ "fanyi" ];
        apps = [ "pass" "nov" "telega" ];
        inputs = [ "agda2-mode" "rime" ];
        test = [
          libs
          core
          "consult"
          "vertico"
          # completion
        ];
      in lib.lists.flatten ([
        # test
        "server"
        libs
        core
        edit
        completion
        lang
        pdf
        tools
        lint
        org
        latex
        dired
        ui
        email
        tramp
        translate
        apps
        inputs
      ] ++ (if (myEnv.arch == "linux") then [ "flymake-sqlfluff" ] else [ ]));
    }
  ];
}
