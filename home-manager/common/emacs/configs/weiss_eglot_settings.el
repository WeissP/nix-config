(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  (add-to-list 'eglot-server-programs '(elixir-mode "elixir-ls"))
  (add-to-list 'eglot-server-programs '(java-mode "jdt-language-server"  "-configuration" "../config-linux" "-data" "../java-workspace"))
  (add-to-list 'eglot-server-programs '(svelte-mode . ("svelteserver" "--stdio")))
  (add-to-list 'eglot-server-programs '(haskell-mode . ("haskell-language-server" "--lsp")))

  (add-to-list 'eglot-ignored-server-capabilities :documentHighlightProvider)
  (add-to-list 'eglot-ignored-server-capabilities :inlayHintProvider)
  
  ;; (add-to-list 'eglot-ignored-server-capabilities :hoverProvider)
  ;; (setq eglot-ignored-server-capabilities nil)
  
  ;; (setq eglot-stay-out-of '(yasnippet))
  ;; (fset #'eglot--snippet-expansion-fn #'ignore)

  (setq eglot-events-buffer-config '(:size 0 :format full))
  (setq-default
   eglot-workspace-configuration
   '((:rust-analyzer . (:diagnostics
                        (:disabled ["unresolved-proc-macro" "type-mismatch"])
                        :check (:overrideCommand ["cargo" "check" "--message-format=json" "--lib" "--workspace" "--all-targets" "--all-features" "--tests"])
                        ;; :check (:overrideCommand ["cargo" "clippy" "--message-format=json" "--all-targets" "--all-features" "--tests"])
                        ;; :checkOnSave (:command "clippy")
                        ))
     (haskell (maxCompletions . 200))
     ))

  ;; (require 'eglot-tempel)
  )
;; rust-analyzer.check.command (default: "check")

(provide 'weiss_eglot_settings)
