(with-eval-after-load 'annotate
  (wks-unset-key annotate-mode-map '("C-c C-p" "C-c C-a"))
  (wks-define-key 
   annotate-mode-map
   ""
   '(
     ("C-c C-M-x a" . annotate-annotate)
     ))
  )

(provide 'weiss_annotate_keybindings)
