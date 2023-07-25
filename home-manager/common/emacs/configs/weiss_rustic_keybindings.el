(with-eval-after-load 'rustic
  (wks-unset-key rustic-mode-map '("C-c C-p" "C-c C-f"))
  (wks-define-key
   rustic-mode-map ""
   '(
     ("C-c C-t t" . rustic-cargo-current-test)
     ("C-c C-t d" . (weiss-rust-insert-dbg (weiss-insert-pair "dbg!(" ")" nil)))
     ))
  )

(provide 'weiss_rustic_keybindings)
