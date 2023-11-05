(with-eval-after-load 'flyspell-correct
  (wks-define-key
   wks-leader-keymap ""
   '(
     ("s c" . flyspell-correct-wrapper)
     )
   )
  )

(provide 'weiss_flyspell-correct_keybindings)
