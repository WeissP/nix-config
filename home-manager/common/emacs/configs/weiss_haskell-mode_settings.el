(defun weiss-haskell-load-process-and-switch-buffer ()
  "DOCSTRING"
  (interactive)
  (haskell-process-load-or-reload)
  (if (one-window-p)
      (progn
        (split-window-below)          
        (other-window 1)
        (switch-to-buffer "*haskell*")
        )
    (other-window 1)
    (unless (string= (buffer-name) "*haskell*")
      (switch-to-buffer "*haskell*")
      )
    )
  )

(defun weiss-haskell-hoogle-lookup ()
  "DOCSTRING"
  (interactive)
  (haskell-hoogle-start-server)
  (let ((url (format "http://localhost:%s/?hoogle=%s"
                     (or (getenv "HOOGLE_PORT") "5432")
                     (car (hoogle-prompt))))
        )
    (message "url: %s" url)
    (browse-url url)
    )
  )


(defun weiss-haskell-insert-module-template ()
  "DOCSTRING"
  (interactive)
  (when (and (= (point-min)
                (point-max))
             (buffer-file-name))
    (insert
     (format haskell-auto-insert-module-format-string (haskell-guess-module-name-from-file-name (buffer-file-name)))
     "\n\nimport MyPrelude\n\n"
     )
    )
  )

(with-eval-after-load 'haskell-mode
  ;; (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  ;; (setq haskell-process-path-ghci "~/.ghcup/bin/ghci-9.0.1")
  ;; (with-eval-after-load 'eglot
  ;;   (add-to-list 'eglot-server-programs
  ;;                '(haskell-mode . ("haskell-language-server-wrapper-1.9.0.0" "--lsp"))))

  ;; (add-hook 'haskell-mode-hook
  ;;           (lambda ()
  ;;             (interactive-haskell-mode t)
  ;;             (haskell-indentation-mode -1)))
  ;; (setq haskell-process-type 'stack-ghci)
  (setq haskell-hoogle-command "hoogle"
        haskell-process-type 'cabal-repl
        )

  (add-hook 'haskell-mode-hook 'weiss-haskell-insert-module-template)
  )

;; parent: 
(provide 'weiss_haskell_settings)
