(with-eval-after-load 'ammonite-term-repl
  (wks-define-key
   ammonite-term-repl-minor-mode-map
   ""
   '(
     ("C-c C-c" . weiss-ammonite-term-repl-send-line)
     ))
  )

(provide 'weiss_ammonite-term-repl_keybindings)
