(add-hook 'emacs-startup-hook (lambda () (require 'lsp-bridge)))

(with-eval-after-load 'lsp-bridge
  (setq acm-enable-preview t
        acm-candidate-match-function 'orderless-flex
        lsp-bridge-nix-lsp-server "nil"
        lsp-bridge-enable-log nil
        )
  (add-hook 'prog-mode-hook #'lsp-bridge-mode)

  ;; (defun weiss-try-show-lsp-bridge-menu (&rest args)
  ;;   (when lsp-bridge-mode
  ;;     (lsp-bridge-popup-complete-menu)
  ;;     )
  ;;   )
  ;; (add-to-list 'acm-continue-commands 'wks-vanilla-mode-enable)
  ;; (advice-add 'wks-vanilla-mode-enable :after #'weiss-try-show-lsp-bridge-menu)
  ;; (advice-add 'delete-backward-char :after #'weiss-try-show-lsp-bridge-menu)
  ;; (advice-add 'backward-delete-char-untabify :after #'weiss-try-show-lsp-bridge-menu)
  )

(provide 'weiss_lsp-bridge_settings)
