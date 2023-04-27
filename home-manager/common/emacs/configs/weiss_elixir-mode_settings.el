(with-eval-after-load 'elixir-mode
  (setq elixir-loaded-p t)
  (require 'project)
  (require 'eglot)
  (add-to-list 'eglot-server-programs '(elixir-mode "elixir-ls"))
  )

(provide 'weiss_elixir_settings)
