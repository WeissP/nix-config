(with-eval-after-load 'consult-omni

  )

(wks-define-key
 (current-global-map)
 ""
 '(
   ("s" . consult-omni-multi)
   ))

(with-eval-after-load 'dired
  (wks-define-key
   dired-mode-map
   ""
   '(
     ("s" . consult-omni-multi)
     ))
  )

(provide 'weiss_consult-omni_keybindings)
