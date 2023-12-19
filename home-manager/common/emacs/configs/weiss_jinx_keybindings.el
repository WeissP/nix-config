(with-eval-after-load 'jinx
  (wks-define-key
   wks-leader-keymap ""
   '(
     ("s c" . jinx-correct)
     )
   )
  )

(provide 'weiss_jinx_keybindings)
