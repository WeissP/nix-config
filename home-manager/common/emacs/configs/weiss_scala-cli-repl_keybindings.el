(with-eval-after-load 'scala-cli-repl
  (wks-define-key
   scala-cli-repl-minor-mode-map
   ""
   '(
     ("C-c C-r" . scala-cli-repl-send-region)
     ("C-c C-c" . weiss-scala-cli-send-paragraph)
     ("C-c C-l" . weiss-scala-cli-send-line)
     ("C-c C-b" . scala-cli-repl-send-buffer)
     ))
  )

(provide 'weiss_scala-cli-repl_keybindings)
