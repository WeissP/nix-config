(defvar recentf-executable (executable-find "recentf"))

(defun weiss-insert-file-to-recentf ()
  "DOCSTRING"
  (interactive)
  (ignore-errors
    (when-let ((name (buffer-file-name)))
      (call-process
       recentf-executable
       nil
       0
       t
       "add"
       name
       )
      ))  

  )

(defun weiss-delete-file-advice (l arg &optional trash)
  "DOCSTRING"
  (interactive)
  (dolist (f l) 
    (ignore-errors
      (call-process
       recentf-executable
       nil
       0
       t
       "remove"
       (car f)
       )))
  )

(advice-add 'dired-internal-do-deletions :after #'weiss-delete-file-advice)
(add-hook 'find-file-hook 'weiss-insert-file-to-recentf)


;; parent: 
(provide 'weiss_recentf-db_settings)


