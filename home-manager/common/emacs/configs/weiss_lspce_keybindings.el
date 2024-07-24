(with-eval-after-load 'lspce
  (wks-define-key
   lspce-mode-map
   ""
   '(
     ("C-c C-a" . lspce-code-actions)
     ("C-c C-d" . eldoc)
     ("C-c C-M-x <f5>" . lspce-restart-workspace)
     ("C-c C-M-x r" . lspce-rename)
     ))
  )

(provide 'weiss_lspce_keybindings)
