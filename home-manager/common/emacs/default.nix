{ inputs, outputs, lib, myLib, config, pkgs, username, ... }:

let userEmacsDirectory = "${myLib.homeDir username}/.emacs.d";
in {
  imports = [ outputs.homeManagerModules.weissEmacs ];

  home.file."${userEmacsDirectory}/weiss-light-theme.el".source =
    ./weiss-light-theme.el;
  home.packages = with pkgs; [
    weissNur.telega-server
    weissNur.emacs-rime
    clj-kondo
    nodePackages.jsonlint
  ];
  programs.weissEmacs = {
    inherit userEmacsDirectory;
    enable = true;
    emacsConfigPath = ./configs;
    chaseSymLink = {
      enable = true;
      absConfigDir =
        "/home/weiss/nix/shared/nix-config/home-manager/common/emacs/configs";
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
      (setq gc-cons-threshold (* (expt 1024 3) 6)
            gc-cons-percentage 0.5
            garbage-collection-messages nil)
    '';
    extraConfig = oldCfg: ''
      (setq vanilla-global-map (current-global-map))
      (setq telega-server-command "${pkgs.weissNur.telega-server.outPath}/bin/telega-server")
      (setq rime--module-path "${pkgs.weissNur.emacs-rime.outPath}/include/librime-emacs.so")
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
    };
    eagerLoad = [
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
      "apheleia"
    ];
    skipInstall = [
      # "telega"
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
      # "weiss-tsc-mode"
      # "weiss-dired-single-handed-mode"
      # "weiss-org-sp"
    ];

    emacsPkgs = let
      libs = [ "s" "exec-path-from-shell" "hydra" "cl-lib" "mode-local" ];
      core = [ "rotate-text" "global" "wks" ];
      edit = [ "puni" "apheleia" "abbrevs" ];
      completion = [
        [ "snails" "snails-custom-backends" ]
        [ "vertico" "vertico-directory" ]
        "orderless"
        "marginalia"
        "consult"
        [ "company" "company-box" ]
      ];
      lang = [
        "cider"
        "python"
        "php-mode"
        "rustic"
        [ "web-mode" "rjsx-mode" "mhtml-mode" [ "http" "auto-rename-tag" ] ]
        [ "go-mode" [ "go-gen-test" "gotest" "go-dlv" "go-impl" "go-eldoc" ] ]
        [ "sql" "ejc-sql" "sql-indent" ]
        [ "haskell-mode" "dante" ]
        "lua-mode"
        "nix-mode"
        [ "dotenv-mode" "yaml-mode" "json-mode" ]
        [ "csv-mode" "ledger-mode" "mustache-mode" "agda2-mode" ]
        "dockerfile-mode"
        "markdown-mode"
      ];
      pdf = [ "pdf-tools" "pdf-view" "pdf-view-restore" ];
      tools = [
        "recentf-db"
        "rg"
        "which-key"
        "super-save"
        "command-log-mode"
        "gud"
        "quickrun"
        "eglot"
        "magit"
        "browse-at-remote"
        "aweshell"
        "gcmh"
        "citre"
        "tab-line"
        [ "tree-sitter" "tree-sitter-langs" "weiss-tsc-mode" ]
      ];
      lint =
        [ [ "flyspell" "wucuo" ] "flymake" "flymake-kondor" "flymake-json" ];
      org = [
        "org"
        "weiss-org-sp"
        [ "ob-go" "ob-sql-mode" ]
        "org-noter"
        [
          "org-roam" # "snails-roam"
        ]
        [ "org-fancy-priorities" "org-appear" ]
        "org-table-to-qmk-keymap"
        "org-edit-latex"
      ];
      latex = [ "auctex" "org-ref" "magic-latex-buffer" "latex-preview-pane" ];
      dired = [
        "dired"
        "wdired"
        [ "diredfl" "all-the-icons-dired" ]
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
        "all-the-icons"
        "display-line-numbers"
      ];
      email = [ "email" "notmuch" ];
      tramp = [ "tramp" "sudo-edit" ];
      translate = [ "fanyi" ];
      apps = [ "telega" "pass" "nov" ];
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
  };
}