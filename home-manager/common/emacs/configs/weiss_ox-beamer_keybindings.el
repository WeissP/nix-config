(with-eval-after-load 'ox-beamer
  (define-key org-beamer-mode-map [remap org-export-dispatch]
              'weiss-org-export-latex-pdf)
  ;; (wks-define-key
  ;;  org-beamer-mode-map
  ;;  ""
  ;;  '(
  ;;    ("t" . weiss-org-export-beamer)
  ;;    ))
  )

(provide 'weiss_ox-beamer_keybindings)
