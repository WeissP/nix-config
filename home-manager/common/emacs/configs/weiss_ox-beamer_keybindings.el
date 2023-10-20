(with-eval-after-load 'ox-beamer
  (wks-define-key
   org-beamer-mode-map
   ""
   '(
     ("t" . weiss-org-export-beamer)
     ))
  )

(provide 'weiss_ox-beamer_keybindings)
