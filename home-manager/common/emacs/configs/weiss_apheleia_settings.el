;; (apheleia-global-mode)

(setq apheleia-mode-lighter nil)
(with-eval-after-load 'apheleia  
  (defun weiss-format-buffer-maybe (&rest args)
    "DOCSTRING"
    (interactive)
    (when (called-interactively-p 'any)      
      (when flymake-mode (flymake-start))
      (when-let (formatters (apheleia--get-formatters))
        (apheleia-format-buffer
         formatters
         (lambda ()
           (save-buffer)
           (when flymake-mode
             (flymake-start)
             (run-with-timer 2 nil #'flymake-start)
             (run-with-timer 4 nil #'flymake-start)
             )                                             
           ))
        (when flymake-mode (run-with-timer 3 nil #'flymake-start))
        )
      )
    )

  (advice-add 'save-buffer :after #'weiss-format-buffer-maybe)

  ;; (setq flymake-mode-hook nil)
  ;; (add-hook 'flymake-mode-hook
  ;;           (lambda () (run-with-idle-timer flymake-no-changes-timeout t #'flymake-start)))


  (push '(scalafmt . ("scalafmt" 
                      (when-let* ((project (project-current))
                                  (root (project-root project)))
                        (list "--config" (expand-file-name ".scalafmt.conf" root)))
                      "--stdin"))
        apheleia-formatters)    
  (push '(zprint . ("zprint" "{:search-config? true}")) apheleia-formatters)    
  ;; (push '(nufmt . ("nufmt" file)) apheleia-formatters)    
  (push '(xmlstarlet . ("xmlstarlet" "format" "--indent-tab")) apheleia-formatters)    
  (push '(rustfmt . ("rustfmt" "--quiet" "--emit" "stdout")) apheleia-formatters)
  (push '(fourmolu . ("fourmolu" "--stdin-input-file" (or (buffer-file-name) (buffer-name)))) apheleia-formatters)
  (push '(cabal-fmt . ("cabal-fmt")) apheleia-formatters)
  (push '(taplo . ("taplo" "fmt" "-")) apheleia-formatters)
  (push '(bibtex-tidy . ("bibtex-tidy" "--merge" "combine" "--blank-lines")) apheleia-formatters)

  ;; (push '(nushell-mode . nufmt) apheleia-mode-alist)
  (push '(scala-mode . scalafmt) apheleia-mode-alist)
  (push '(haskell-cabal-mode . cabal-fmt) apheleia-mode-alist)
  (push '(haskell-mode . fourmolu) apheleia-mode-alist)
  (push '(clojurescript-mode . zprint) apheleia-mode-alist)
  (push '(clojure-mode . zprint) apheleia-mode-alist)
  (push '(nxml-mode . xmlstarlet) apheleia-mode-alist)
  (push '(bibtex-mode . bibtex-tidy) apheleia-mode-alist)

  (with-eval-after-load 'conf-mode
    (push '(conf-toml-mode . taplo) apheleia-mode-alist)
    )
  )

(provide 'weiss_apheleia_settings)

