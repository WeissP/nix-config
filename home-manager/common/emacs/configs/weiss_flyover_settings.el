(add-hook 'flymake-mode-hook #'flyover-mode)

(defun weiss-test ()
  "DOCSTRING"
  (interactive)
  ;; (flyover--maybe-display-errors-debounced)
  (flyover--maybe-display-errors))

(with-eval-after-load 'flyover
  
  ;; (require 'flyover)
  ;; Use theme colors for error/warning/info faces
  (setq flyover-use-theme-colors t)
  (setq flyover-text-tint 'lighter) 

  ;; "Percentage to lighten or darken the text when tinting is enabled."
  (setq flyover-text-tint-percent 85)
  (setq flyover-base-height 1.0)
  (setq flyover-levels '(error))
  )

(provide 'weiss_flyover_settings)
