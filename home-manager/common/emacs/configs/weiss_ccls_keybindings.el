(with-eval-after-load 'ccls
  (let ((keys '("," "/" ":" ".")))
    (wks-unset-key c-mode-map keys)
    (wks-unset-key c++-mode-map keys)    
    )
  )

;; parent: lsp-mode
(provide 'weiss_ccls_keybindings)

