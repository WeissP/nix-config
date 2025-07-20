(with-eval-after-load 'uniline
  (wks-define-key
   uniline-mode-map
   ""
   '(
     ("<f5>" . uniline-launch-interface)
     ("RET" . uniline-set-brush-nil)
     ("<return>" . uniline-set-brush-nil)
     ))
  )

(provide 'weiss_uniline_keybindings)
