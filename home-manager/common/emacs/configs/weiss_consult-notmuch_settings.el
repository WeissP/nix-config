(defun weiss-consult-notmuch-tree ()
  "DOCSTRING"
  (interactive)
  (consult-notmuch--tree (consult-notmuch--search "(not is:unimportant) and")))

(with-eval-after-load 'consult-notmuch
  )

(provide 'weiss_consult-notmuch_settings)
