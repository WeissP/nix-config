(with-eval-after-load 'lsp-bridge
  (define-key lsp-bridge-mode-map [remap xref-find-definitions] 'lsp-bridge-find-def)
  (wks-define-key
   lsp-bridge-mode-map
   ""
   '(
     ("C-c C-a" . lsp-bridge-code-action)
     ("C-c C-b" . lsp-bridge-find-def-return)
     ("C-c C-d" . lsp-bridge-show-documentation)
     ("<home>" . acm-filter)
     ("M-SPC" . acm-filter)
     ("C-c C-M-x <f5>" . lsp-bridge-restart-process)
     ("C-c C-M-x r" . lsp-bridge-rename)
     ;; ("C-c C-p" . lsp-bridge-peek)
     ("C-c C-f" . lsp-bridge-diagnostic-list)
     ("y <up>" . lsp-bridge-diagnostic-jump-prev)
     ("y <down>" . lsp-bridge-diagnostic-jump-next)
     ))
  
  (wks-unset-key acm-mode-map '("<tab>"))
  (defun weiss-show-acm (&rest args)
    "DOCSTRING"
    (interactive)
    (message "acm-hidden"  ))
  ;; (defun acm--pre-command ()
  ;;   ;; Use `pre-command-hook' to hide completion menu when command match `acm-continue-commands'.
  ;;   (let ((cmd this-command))
  ;;     (message "this-command: %s" this-command)
  ;;     (message "acm-match-symbol-p: %s" (acm-match-symbol-p acm-continue-commands cmd))
  ;;     ;; (unless (acm-match-symbol-p acm-continue-commands cmd)
  ;;     ;;   (acm-hide))
  ;;     )    
  ;;   )

  ;; (advice-add 'acm-hide :after #'weiss-show-acm)
  
  (wks-define-key
   lsp-bridge-peek-keymap
   ""
   '(
     ("<down>" . lsp-bridge-peek-file-content-next-line)
     ("<up>" . lsp-bridge-peek-file-content-prev-line)
     ("<left>" . lsp-bridge-peek-list-prev-line)
     ("<right>" . lsp-bridge-peek-list-next-line)
     ("C-c C-p" . lsp-bridge-peek-through)
     ("C-c C-j" . lsp-bridge-peek-tree-next-branch)
     ("C-c C-k" . lsp-bridge-peek-tree-previous-branch)
     ("C-c C-i" . lsp-bridge-peek-tree-previous-node)
     ("C-c C-l" . lsp-bridge-peek-tree-next-node)
     ;; ("C-c C-t" . citre-peek-jump)
     ))

  )

(provide 'weiss_lsp-bridge_keybindings)
