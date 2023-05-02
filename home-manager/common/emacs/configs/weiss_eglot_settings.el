(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  (add-to-list 'eglot-server-programs '(elixir-mode "elixir-ls"))
  (add-to-list 'eglot-server-programs '(java-mode "jdt-language-server"  "-configuration" "../config-linux" "-data" "../java-workspace"))
  (add-to-list 'eglot-ignored-server-capabilities :documentHighlightProvider)
  (setq-default
   eglot-workspace-configuration
   '((:rust-analyzer . (:diagnostics
                        (:disabled ["unresolved-proc-macro" "type-mismatch"])
                        :check (:command "check")
                        ;; :check (:command "clippy")
                        ))))
  )
;; rust-analyzer.check.command (default: "check")

(provide 'weiss_eglot_settings)
