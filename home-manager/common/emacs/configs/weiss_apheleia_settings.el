;; (apheleia-global-mode)

(setq apheleia-mode-lighter nil)
(defun weiss-format-buffer-maybe (&rest args)
  "DOCSTRING"
  (interactive)
  (when (called-interactively-p 'any)      
    (when (featurep 'flyover) (flyover--clear-overlays))
    (when flymake-mode (flymake-start))
    (if-let (formatters (apheleia--get-formatters))
        (progn
          (when (featurep 'flyover)
            (flyover--clear-overlays)
            (flyover-mode 1)
            )
          (apheleia-format-buffer
           formatters
           (lambda ()
             (save-buffer)
             (when flymake-mode
               (flymake-start)
               (run-with-timer 1 nil #'flymake-start)
               (run-with-timer 3 nil #'flymake-start)
               (when (featurep 'flyover)
                 (flyover--clear-overlays)
                 (run-with-timer 2 nil #'(lambda () (flyover-mode 1)))
                 (run-with-timer 3.8 nil #'(lambda () (flyover--clear-overlays)))
                 (run-with-timer 4 nil #'(lambda () (flyover-mode 1)))
                 (run-with-timer 5.8 nil #'(lambda () (flyover--clear-overlays)))
                 (run-with-timer 6 nil #'(lambda () (flyover-mode 1)))
                 )
               )                                             
             ))
          )
      (when flymake-mode 
        (run-with-timer 2 nil #'flymake-start)
        (when (featurep 'flyover)
          (run-with-timer 4 nil #'(lambda () (flyover-mode 1)))
          )
        )
      )
    )
  )
(with-eval-after-load 'apheleia
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
  ;; (push '(nufmt . ("nufmt" "-s")) apheleia-formatters)    
  (push '(xmlstarlet . ("xmlstarlet" "format" "--indent-tab")) apheleia-formatters)    
  (push '(rustfmt . ("rustfmt" "--quiet" "--emit" "stdout")) apheleia-formatters)
  (push '(fourmolu . ("fourmolu" "--stdin-input-file" (or (buffer-file-name) (buffer-name)))) apheleia-formatters)
  (push '(cabal-fmt . ("cabal-fmt")) apheleia-formatters)
  (push '(taplo . ("taplo" "fmt" "-")) apheleia-formatters)
  (push '(bibtex-tidy . ("bibtex-tidy" "--merge" "combine" "--blank-lines")) apheleia-formatters)
  (push '(google-java-format . ("google-java-format" "-")) apheleia-formatters)

  ;; (push '(nushell-mode . nufmt) apheleia-mode-alist)
  (push '(scala-mode . scalafmt) apheleia-mode-alist)
  (push '(haskell-cabal-mode . cabal-fmt) apheleia-mode-alist)
  (push '(haskell-mode . fourmolu) apheleia-mode-alist)
  (push '(clojurescript-mode . zprint) apheleia-mode-alist)
  (push '(clojure-mode . zprint) apheleia-mode-alist)
  (push '(nxml-mode . xmlstarlet) apheleia-mode-alist)
  (push '(bibtex-mode . bibtex-tidy) apheleia-mode-alist)
  (push '(java-mode . google-java-format) apheleia-mode-alist)

  (with-eval-after-load 'conf-mode
    (push '(conf-toml-mode . taplo) apheleia-mode-alist)
    )
  )

(provide 'weiss_apheleia_settings)

