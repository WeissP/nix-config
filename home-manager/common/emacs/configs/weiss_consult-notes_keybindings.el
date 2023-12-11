(with-eval-after-load 'consult-notes
  (wks-define-key
   (current-global-map)
   ""
   '(
     ("2" . consult-notes)
     ))
  )

(provide 'weiss_consult-notes_keybindings)
