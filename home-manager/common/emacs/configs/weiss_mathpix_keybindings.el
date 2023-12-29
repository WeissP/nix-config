(with-eval-after-load 'org
  (wks-define-key
   org-mode-map ""
   '(
     ("C-c C-p" . mathpix-insert-and-preview)
     ))
  )

(with-eval-after-load 'latex
  (wks-define-key
   LaTeX-mode-map ""
   '(("C-c C-M-x p" . mathpix-insert)
     )
   )
  )

(provide 'weiss_mathpix_keybindings)
