(with-eval-after-load 'maxima
  (wks-define-key
   maxima-mode-map
   ""
   '(
     ("C-c C-SPC" . maxima-latex-insert-form)
     ))
  )

(provide 'weiss_maxima_keybindings)
