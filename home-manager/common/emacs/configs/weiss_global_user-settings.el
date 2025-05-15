(defvar weiss/cursor-color "#4078f2")
(defvar weiss/cursor-type '(bar . 2))

(setq disabled-command-function nil)

(setq-default c-basic-offset   4
              tab-width        4
              indent-tabs-mode nil)
(setq
 large-file-warning-threshold 100000000
 ring-bell-function 'ignore
 auto-save-default nil ; Disable auto save
 make-backup-files nil ; Forbide to make backup files
 create-lockfiles nil)

(set-cursor-color weiss/cursor-color)
(setq-default cursor-type weiss/cursor-type)

(setq y-or-n-p-use-read-key t)
(fset 'yes-or-no-p 'y-or-n-p)

(save-place-mode -1)
(delete-selection-mode 1)
(global-auto-revert-mode 1)
(blink-cursor-mode -1)
(show-paren-mode -1)
(add-hook 'prog-mode-hook #'subword-mode)
(add-hook 'minibuffer-setup-hook #'subword-mode)

;; Encoding
;; UTF-8 as the default coding system
(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))

;; Explicitly set the prefered coding systems to avoid annoying prompt
;; from emacs (especially on Microsoft Windows)
(prefer-coding-system 'utf-8)

(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)

(setq locale-coding-system 'utf-8
      default-process-coding-system
      '(utf-8-unix . utf-8-unix)
      )

;; save sh file auto with executable permission
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(setq
 eval-expression-print-level nil
 eval-expression-print-length nil)

(setq enable-recursive-minibuffers t)
(setq minibuffer-eldef-shorten-default t)

(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

(setq resize-mini-windows t)
(setq minibuffer-eldef-shorten-default t)

(file-name-shadow-mode 1)
(minibuffer-depth-indicate-mode 1)
(minibuffer-electric-default-mode 1)


;;; Minibuffer history
(require 'savehist)
(setq savehist-file (locate-user-emacs-file "savehist"))
(setq history-length 10000)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history t)
(add-hook 'after-init-hook #'savehist-mode)
(defvar weiss-lint-hook nil "hook for check lint")
(setq auth-sources '("~/.authinfo.gpg" "~/.authinfo"))

(setq kill-ring-max 9999)

(setq warning-suppress-types '((undo discard-info)))

(setq completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion)))
      )

(setq
 weiss/notes-dir (file-name-as-directory (expand-file-name "~/Documents/notes/"))
 weiss/chats-dir (file-name-as-directory (expand-file-name "~/Documents/chats/"))
 weiss/academic-dir (file-name-as-directory weiss/notes-dir)
 weiss/academic-documents (file-name-as-directory (concat weiss/academic-dir "papers"))
 weiss/bibs (list
             (concat
              weiss/academic-documents
              "20240413T081114--bibliography__academic.bib")
             (concat
              weiss/academic-documents
              "zotero.bib"))
 )

(provide 'weiss_global_user-settings)
