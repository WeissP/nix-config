(with-eval-after-load 'string-inflection
  (with-eval-after-load 'embark
    (wks-define-key
     embark-region-map
     ""
     '(
       ("_" . weiss-string-inflection-cycle-auto)
       ))
    (wks-define-key
     embark-identifier-map
     ""
     '(
       ("_" . weiss-string-inflection-cycle-auto)
       ))
    )
  )

(provide 'weiss_string-inflection_keybindings)
