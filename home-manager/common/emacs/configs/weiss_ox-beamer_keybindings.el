(with-eval-after-load 'org
  (require 'ox-beamer)
  (defun weiss-org-export-beamer ()
    "DOCSTRING"
    (interactive)
    (call-interactively 'save-buffer)
    (org-beamer-export-to-pdf)
    )

  (wks-define-key
   org-beamer-mode-map
   ""
   '(
     ("t" . weiss-org-export-beamer)
     ))
  )

(provide 'weiss_ox-beamer_keybindings)
