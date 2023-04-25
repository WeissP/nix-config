(defvar recentf-executable (executable-find "recentf"))

(defun weiss-insert-file-to-recentf (filename &optional nowarn rawfile wildcards)
  "DOCSTRING"
  (interactive)
  (ignore-errors
    (call-process
       recentf-executable
       nil
       0
       t
       "add"
       filename
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
(advice-add 'find-file-noselect :after #'weiss-insert-file-to-recentf)

;; parent: 
(provide 'weiss_recentf-db_settings)


