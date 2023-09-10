(require 'separedit)

(with-eval-after-load 'separedit
  (wks-define-key
   rustic-mode-map ""
   '(
     ("C-c '" . separedit)
     ))
  )

(provide 'weiss_separedit_keybindings)
