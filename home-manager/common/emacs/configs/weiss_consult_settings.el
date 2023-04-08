;; -*- lexical-binding: t -*-

(with-eval-after-load 'consult
  (defun weiss-emacs-config-files (&rest args)
    "DOCSTRING"
    (interactive)
    (directory-files weiss/configs-dir t "^[^.]")
    )
  (setq weiss-consult--emacs-config
        `(:name     "Emacs-Config"
                    :narrow   ?e
                    :category Config
                    :face     consult-buffer
                    :state    ,#'consult--buffer-state
                    :default  t
                    :require-match nil
                    :new ,(lambda (&rest args) (message "new args: %s" args))
                    :action ,(lambda (&rest args) (message "args: %s" args))
                    :items weiss-emacs-config-files
                    )
        )

  (add-to-list 'consult-buffer-sources
               weiss-consult--emacs-config
               'append)
  )

(provide 'weiss_consult_settings)
