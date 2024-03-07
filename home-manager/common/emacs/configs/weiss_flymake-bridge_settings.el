(with-eval-after-load 'lsp-bridge
  (require 'flymake-bridge)

  (defun weiss-flymake-bridge-setup ()
    "DOCSTRING"
    (flymake-bridge-setup)
    (wks-unset-key lsp-bridge-mode-map '("C-c C-f" "y <up>" "y <down>"))
    )

  (add-hook 'lsp-bridge-mode-hook #'weiss-flymake-bridge-setup)
  )

(provide 'weiss_flymake-bridge_settings)
