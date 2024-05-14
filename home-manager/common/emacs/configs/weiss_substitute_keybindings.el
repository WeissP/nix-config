(with-eval-after-load 'substitute
  (wks-unset-key wks-leader-keymap '("r"))

  (wks-define-key
   wks-leader-keymap
   "r "
   '(
     ("b" . substitute-target-in-buffer)
     ("d" . substitute-target-in-defun)
     ("j" . substitute-target-below-point)
     ("k" . substitute-target-above-point)
     ("a" . anzu-query-replace)
     ("r" . anzu-query-replace-regexp)
     ))
  )

(provide 'weiss_substitute_keybindings)
