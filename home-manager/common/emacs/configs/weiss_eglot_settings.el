(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  (add-to-list 'eglot-server-programs '(elixir-mode "elixir-ls"))
  (add-to-list 'eglot-server-programs '(java-mode "jdt-language-server"  "-configuration" "../config-linux" "-data" "../java-workspace"))
  (add-to-list 'eglot-ignored-server-capabilities :documentHighlightProvider)
  (add-to-list 'eglot-ignored-server-capabilities :inlayHintProvider)
  ;; (setq eglot-ignored-server-capabilities nil)
  (setq-default
   eglot-workspace-configuration
   '((:rust-analyzer . (:diagnostics
                        (:disabled ["unresolved-proc-macro" "type-mismatch"])
                        :check (:overrideCommand ["cargo" "check" "--message-format=json" "--all-targets" "--all-features" "--tests"]);; :check (:command "clippy")
                        ))))

  )
;; rust-analyzer.check.command (default: "check")

(provide 'weiss_eglot_settings)
