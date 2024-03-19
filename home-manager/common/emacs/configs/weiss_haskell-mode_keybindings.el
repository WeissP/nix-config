(with-eval-after-load 'haskell-mode
  (wks-unset-key haskell-indentation-mode-map '(","))
  (wks-define-key
   haskell-mode-map
   ""
   '(
     ("C-c C-s" . haskell-hoogle)
     ("-" . weiss-haskell-load-process-and-switch-buffer)
     ))  
  )

(with-eval-after-load 'haskell-cabal
  (add-hook 'haskell-cabal-mode-hook #'display-line-numbers-mode)
  (wks-define-key
   haskell-cabal-mode-map
   ""
   '(
     ("<tab>" . save-buffer)
     ))  
  )

(with-eval-after-load 'haskell-indentation-mode
  (wks-unset-key haskell-indentation-mode-map '(";"))
  )

(with-eval-after-load 'haskell-interactive-mode
  (wks-unset-key haskell-interactive-mode-map '("SPC"))
  (wks-define-key
   haskell-interactive-mode-map
   ""
   '(
     ("<up>" . haskell-interactive-mode-history-previous)
     ("<down>" . haskell-interactive-mode-history-next)
     ))
  )

;; parent: 
(provide 'weiss_haskell_keybindings)
