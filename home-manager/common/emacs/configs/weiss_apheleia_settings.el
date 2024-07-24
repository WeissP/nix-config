;; (apheleia-global-mode)
(setq apheleia-mode-lighter nil)
(with-eval-after-load 'apheleia  
  (defun weiss-format-buffer-maybe (&rest args)
    "DOCSTRING"
    (interactive)
    (when (called-interactively-p 'any)
      (call-interactively 'apheleia-format-buffer))
    )

  (advice-add 'save-buffer :after #'weiss-format-buffer-maybe)

  (push '(scalafmt . ("scalafmt"
                      (when-let* ((project (project-current))
                                  (root (project-root project)))
                        (list "--config" (expand-file-name ".scalafmt.conf" root)))
                      filepath
                      "--stdout"))
        apheleia-formatters)    
  (push '(zprint . ("zprint")) apheleia-formatters)    
  ;; (push '(nufmt . ("nufmt" file)) apheleia-formatters)    
  (push '(xmlstarlet . ("xmlstarlet" "format" "--indent-tab")) apheleia-formatters)    
  (push '(rustfmt . ("rustfmt" "--quiet" "--emit" "stdout")) apheleia-formatters)
  (push '(fourmolu . ("fourmolu" "--stdin-input-file" (or (buffer-file-name) (buffer-name)))) apheleia-formatters)
  (push '(cabal-fmt . ("cabal-fmt")) apheleia-formatters)

  ;; (push '(nushell-mode . nufmt) apheleia-mode-alist)
  (push '(scala-mode . scalafmt) apheleia-mode-alist)
  (push '(haskell-cabal-mode . cabal-fmt) apheleia-mode-alist)
  (push '(haskell-mode . fourmolu) apheleia-mode-alist)
  (push '(clojurescript-mode . zprint) apheleia-mode-alist)
  (push '(clojure-mode . zprint) apheleia-mode-alist)
  (push '(nxml-mode . xmlstarlet) apheleia-mode-alist)
  )

(provide 'weiss_apheleia_settings)

