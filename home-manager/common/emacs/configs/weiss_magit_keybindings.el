(with-eval-after-load 'magit
  (wks-unset-key magit-status-mode-map '("SPC" "-" "a" "$") :all-numbers)
  (wks-unset-key magit-revision-mode-map '("$") :all-numbers)
  (wks-define-key
   magit-status-mode-map
   ""
   '(
     ("=" . magit-cherry-apply)
     ))
  )

(provide 'weiss_magit_keybindings)
