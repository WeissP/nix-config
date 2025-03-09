(with-eval-after-load 'clojure-mode
  (add-hook 'clojure-mode-hook 'cider-mode)
  (add-hook 'clojurescript-mode-hook 'cider-mode)
  (defvar weiss-cider-repl-reload-file nil)
  (require 'clojure-mode-extra-font-locking)
  (setq 
   clojure-toplevel-inside-comment-form t
   nrepl-sync-request-timeout nil
   )
  )

;; (require 'clojure-mode)
(with-eval-after-load 'cider

  (advice-add 'cider-debug-defun-at-point :before #'deactivate-mark)
  (advice-add 'cider-eval-defun-at-point :before #'deactivate-mark)

  (with-eval-after-load 'embark
    
    (defun weiss-cider-embark-eval-region (start end)
      "DOCSTRING"
      (interactive "r")
      (when (eq major-mode 'clojure-mode)
        (cider-eval-region start end)
        )      
      )
    (defun weiss-cider-embark-pprint-region (start end)
      "DOCSTRING"
      (interactive "r")
      (when (eq major-mode 'clojure-mode)
        (cider--pprint-eval-form (cons start end))
        )      
      )
    (advice-add 'weiss-embark-eval-and-output-region
                :before-until #'weiss-cider-embark-eval-region)
    )
  
  (defun weiss-cider-save-and-load ()
    "DOCSTRING"
    (interactive)
    (save-buffer)
    (if current-prefix-arg
        (cider-load-all-project-ns)
      (cider-load-buffer)      
      )
    (when weiss-cider-repl-reload-file      
      (cider-eval-file (f-join (or (getenv "PRJ_ROOT") "") weiss-cider-repl-reload-file))
      )
    )

  (defun weiss-test ()
    "DOCSTRING"
    (interactive)
    (message ": %s" (f-join (or (getenv "PRJ_ROOT") "") weiss-cider-repl-reload-file))  )

  (defun weiss-cider-repl-refresh ()
    "DOCSTRING"
    (interactive)
    (save-buffer)
    (cider-ns-refresh)
    (unless (one-window-p)
      (weiss-switch-buffer-or-otherside-frame-without-top)))

  (defun weiss-cider-true-restart ()
    "DOCSTRING"
    (interactive)
    (call-interactively 'cider-quit)
    (call-interactively 'cider-jack-in)
    )

  (defun weiss-cider-eval-last-sexp-this-line ()
    "DOCSTRING"
    (interactive)
    (end-of-line)
    (if current-prefix-arg
        (cider-eval-defun-at-point t)
      (cider-eval-last-sexp)))

  (defun weiss-cider-connect-babashka (arg)
    "DOCSTRING"
    (interactive "P")
    (if arg
        (call-interactively 'cider-connect-clj)
      (cider-nrepl-connect
       (thread-first
         '(:host "localhost" :port 1667)
         (cider--update-project-dir)
         (cider--update-host-port)
         (cider--check-existing-session)
         (plist-put :repl-init-function nil)
         (plist-put :session-name nil)
         (plist-put :repl-type 'clj)))))

  (with-eval-after-load 'org
    (require 'ob-clojure)
    (setq org-babel-clojure-backend 'cider)
    )
  )

;; parent: 
(provide 'weiss_cider_settings)
