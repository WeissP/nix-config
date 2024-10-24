(with-eval-after-load 'direnv
  (direnv-mode)
  (setq direnv-always-show-summary nil)
  )

(add-to-list 'warning-suppress-types '(direnv))

(defun weiss-test ()
  "DOCSTRING"
  (interactive)
  (message ": %s" (direnv--export "/home/weiss/projects/digiVine/federated-api/")))

(defun weiss-test ()
  "DOCSTRING"
  (interactive)
  (call-process
   direnv--executable nil
   '(t "/home/weiss/tmp.log") nil
   "export" "json"))

(provide 'weiss_direnv_settings)
