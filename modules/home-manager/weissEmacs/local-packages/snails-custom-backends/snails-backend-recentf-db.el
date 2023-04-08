;;; Require
(require 'snails-core)

(setq recentf-executable
      (or (executable-find "recentf") "~/rust/recentf/recentf"))

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
  (ignore-errors
    (when-let ((name (buffer-file-name)))
      (call-process
       "/home/weiss/nix/shared/recentf/recentf_bin"
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
       "/home/weiss/nix/shared/recentf/recentf_bin"
       nil
       0
       t
       "remove"
       (car f)
       )))
  )

(advice-add 'dired-internal-do-deletions :after #'weiss-delete-file-advice)
(add-hook 'find-file-hook 'weiss-insert-file-to-recentf)

(defun snails-backend-recentf-root ()
  "Find projectile root."
  (if (file-remote-p (snails-start-buffer-dir))
      ;; "/ssh:lamp@scilab-0019.cs.uni-kl.de:/home"
      (snails-start-buffer-dir)
    (when (ignore-errors (require 'projectile))
      ;; (message "snails-start-buffer-dir:%s"
      ;;          (snails-start-buffer-dir))
      ;; (message "%s" (projectile-project-root (snails-start-buffer-dir)))
      (or (projectile-project-root (snails-start-buffer-dir)) "nil"))))

(snails-create-async-backend
 :name "RECENTF-DB"

 :build-command (lambda
                  (input)
                  (when (> (length input) 1)
                    (append
                     '("~/rust/recentf/recentf"
                       "prefixed-search"
                       )
                     (split-string input  " ")
                     )
                    ))

 :candidate-filter (lambda
                     (candidate-list)
                     (let (candidates)
                       (dolist (candidate candidate-list)
                         (let* ((l (split-string candidate "』𝔰𝔢𝔭『"))
                                (show (weiss-reduce-file-path (car l)))
                                (value (nth 1 l)))
                           (when value
                             (snails-add-candiate 'candidates show value))))
                       candidates))

 :candidate-do (lambda (candidate) (find-file candidate)))

(defun weiss-test ()
  "DOCSTRING"
  (interactive)
  (snails '(snails-backend-recentf-db)))

(provide 'snails-backend-recentf-db)
