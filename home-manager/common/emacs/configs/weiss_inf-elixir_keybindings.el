(with-eval-after-load 'inf-elixir
  (wks-define-key
   inf-elixir-mode-map
   ""
   '(
     ("t t" . inf-elixir-send-line)
     ("t r" . inf-elixir-send-region)
     ("t b" . inf-elixir-send-buffer)
     ("t g" . inf-elixir-reload-module)
     ))
  )

(provide 'weiss_inf-elixir_keybindings)
