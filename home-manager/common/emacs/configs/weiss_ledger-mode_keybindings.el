(with-eval-after-load 'ledger-mode
  (wks-define-key
   ledger-mode-map
   ""
   '(("<tab>" . save-buffer)
     ("C-c '" . ledger-navigate-next-uncleared)
     ))
  )

(provide 'weiss_ledger-mode_keybindings)
