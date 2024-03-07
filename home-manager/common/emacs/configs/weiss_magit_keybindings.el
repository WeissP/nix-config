(with-eval-after-load 'magit
  (wks-unset-key magit-status-mode-map '("SPC" "-" "a" "$" "^") :all-numbers)
  (wks-unset-key magit-revision-mode-map '("$" "^") :all-numbers)
  (wks-define-key
   magit-status-mode-map
   ""
   '(
     ("=" . magit-cherry-apply)
     ))
  )

(let ((xx nil))
  (pcase xx
    (13 1)
    ('a 2)
    (functionp 3)
    (_ 0)
    )
  )

(provide 'weiss_magit_keybindings)
