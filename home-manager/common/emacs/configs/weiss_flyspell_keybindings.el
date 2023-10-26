(with-eval-after-load 'flyspell
  (with-eval-after-load 'org-mode
    (wks-define-key
     org-mode-map ""
     '(("C-c C-M-x c" . flyspell-auto-correct-word)))
    )

  (with-eval-after-load 'latex
    (wks-define-key
     LaTeX-mode-map ""
     '(("C-c C-M-x c" . flyspell-auto-correct-word)))
    )
  )

;; parent: 
(provide 'weiss_flyspell_keybindings)
