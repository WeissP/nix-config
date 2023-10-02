(with-eval-after-load 'separedit
  (with-eval-after-load 'rustic
    (wks-define-key
     rustic-mode-map ""
     '(
       ("C-c '" . separedit)
       ))
    )
  )

(provide 'weiss_separedit_keybindings)
