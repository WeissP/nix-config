{ inputs, outputs, lib, myEnv, config, secrets, pkgs, ... }:
with myEnv;
let userEmacsDirectory = "${homeDir}/.emacs.d";
in {
  imports = [ outputs.homeManagerModules.weissEmacs ../recentf.nix ];

  home.file."${userEmacsDirectory}/weiss-light-theme.el".source =
    if (arch == "darwin") then
      ./weiss-light-theme-mac.el
    else
      ./weiss-light-theme.el;
  home.packages = with pkgs; [ clj-kondo nodePackages.jsonlint nixfmt ];
  programs.weissEmacs = lib.mkMerge [
    (ifDarwin { package = pkgs.emacs29-pgtk; })
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

        ${oldCfg}
      '';

      localPkg = {
        enable = true;
        dir = ./local-packages;
      };
      autoload = {
        s = [ "s-replace" ];
        dired-quick-sort = [ "hydra-dired-quick-sort/body" ];
        puni = [ "puni-strict-forward-sexp" "puni-strict-backward-sexp" ];
        pdf-view = [ "pdf-view-mode" ];
        dired-single-handed-mode = [ "weiss-dired-single-handed-mode" ];
        rotate-text = [ "rotate-text" ];
        weiss-tsc-mode = [ "weiss-tsc-mode" ];
        org-edit-latex = [ "org-edit-latex-mode" ];
        eglot-java = [ "eglot-java-mode" ];
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
      ];
      idleLoad = {
        enable = true;
        idleSeconds = 3;
        packages = [ "eglot" "org" "org-roam" "pdf-view" ];
      };
      skipInstall = [
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
        "gud"
        "aweshell"
        "tab-line"
        "snails-roam"
        "wdired"
        "hl-line"
        "whitespace"
        "display-line-numbers"
        "snails"
        "snails-custom-backends"
        "recentf-db"
        "latex"
        # "weiss-tsc-mode"
        # "weiss-dired-single-handed-mode"
        # "weiss-org-sp"
      ];

      emacsPkgs = let
        libs = [ "s" "exec-path-from-shell" "hydra" "cl-lib" "mode-local" "f" ];
        core = [ "rotate-text" "global" "wks" ];
        edit = [ "puni" "apheleia" "abbrevs" "separedit" ];
        completion = [
          [ "snails" "snails-custom-backends" ]
          [ "vertico" "vertico-directory" ]
          "orderless"
          "marginalia"
          "consult"
          [ "company" "company-box" ]
        ];
        lang = [
          [ "elixir-mode" "flymake-elixir" "inf-elixir" "ob-elixir" ]
          "cider"
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
          [ "sql" "ejc-sql" "sql-indent" "flymake-sqlfluff" ]
          [ "haskell-mode" "dante" ]
          "lua-mode"
          "nix-mode"
          [ "dotenv-mode" "yaml-mode" "json-mode" ]
          [ "csv-mode" "ledger-mode" "mustache-mode" "agda2-mode" ]
          "dockerfile-mode"
          "markdown-mode"
          "ess"
        ];
        pdf =
          [ "pdf-tools" "pdf-view" "pdf-view-restore" "literate-calc-mode" ];
        tools = [
          "direnv"
          "project"
          "recentf-db"
          "rg"
          "which-key"
          "super-save"
          "command-log-mode"
          "gud"
          "quickrun"
          [ "eglot" "eglot-java" ]
          "magit"
          "browse-at-remote"
          "aweshell"
          "gcmh"
          "citre"
          "tab-line"
          "mind-wave"
          "polymode"
          "tla-tools"
          "use-proxy"
          # "maxima"
          # [ "tree-sitter" "tree-sitter-langs" "weiss-tsc-mode" ]
        ];
        lint =
          [ [ "flyspell" "wucuo" ] "flymake" "flymake-kondor" "flymake-json" ];
        org = [
          "org"
          "weiss-org-sp"
          [ "ob-go" "ob-sql-mode" ]
          "org-noter"
          [ "org-roam" "snails-roam" ]
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
          [
            "diredfl" # "all-the-icons-dired"
            "nerd-icons-dired"
          ]
          [ "dired-filter" "dired-avfs" "dired-collapse" "dired-quick-sort" ]
          "dired-hacks-utils"
          "peep-dired"
          "dired-single-handed-mode"
        ];
        ui = [
          "ui"
          [ "modeline" "delight" ]
          "popwin"
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
        inputs = [ "agda-input" "rime" ];
      in lib.lists.flatten [
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
      ];
    }
  ];
}
