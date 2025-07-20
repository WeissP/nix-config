(defun nov-scroll-lines ()
  "DOCSTRING"
  (floor (/ (window-total-height) 3)))

(defun weiss-test ()
  "DOCSTRING"
  (interactive)
  (nov-scroll-up 5 )  )

(with-eval-after-load 'nov
  (wks-unset-key nov-mode-map '("SPC" "l" "<end>" "i" "a" "n" "g") :numbers)
  (wks-unset-key nov-button-map '("SPC" "l" "<end>" "i"))

  (wks-define-key
   nov-mode-map ""
   '(("<down>" . (weiss-nov-scroll-up (nov-scroll-up (nov-scroll-lines))))
     ("<up>" . nov-scroll-down)     
     ("," . nov-history-back)     
     ("." . nov-history-forward)
     ("e" . weiss-nov-explain-word)
     ("C-c C-s" . weiss-store-nov-link)
     ))
  )

(provide 'weiss_nov_keybindings)
