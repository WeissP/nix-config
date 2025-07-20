(defun weiss-emacs-server-p ()
  "DOCSTRING"
  (interactive)
  (getenv "Emacs_Server_Process"))

(add-hook 'after-init-hook
          (lambda ()
            (ignore-errors
              (when (weiss-emacs-server-p)
                (server-mode))
              )))

;; parent: 
(provide 'weiss_server_settings)
