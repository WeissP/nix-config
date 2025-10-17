(add-to-list 'completion-at-point-functions #'cape-dabbrev)
(add-to-list 'completion-at-point-functions #'cape-file)
(add-to-list 'completion-at-point-functions #'cape-elisp-block)

(with-eval-after-load 'cape
  (with-eval-after-load 'org-msg
    (setq-mode-local
     org-msg-edit-mode
     completion-at-point-functions
     (-concat 
      (mapcar #'cape-company-to-capf (list #'notmuch-company))
      '(pcomplete-completions-at-point cape-dict t)))

    ;; (advice-add 'org-msg-post-setup :after #'weiss-set-org-msg-edit-mode-capfs)
    ;; (advice-remove 'org-msg-post-setup  #'weiss-set-org-msg-edit-mode-capfs)
    ;; (advice-add 'org-msg-post-setup--if-not-reply :after #'weiss-set-org-msg-edit-mode-capfs)
    ;; (defun weiss-set-org-msg-edit-mode-capfs (&rest args)
    ;;   "DOCSTRING" 
    ;;   (interactive)
    ;;   (message "setup capfs" )
    ;;   (add-hook 'completion-at-point-functions (cape-company-to-capf #'notmuch-company) nil t)
    ;;   ;; (setq
    ;;   ;;  completion-at-point-functions
    ;;   ;;  (-concat 
    ;;   ;;   (mapcar #'cape-company-to-capf (list #'notmuch-company))
    ;;   ;;   '(pcomplete-completions-at-point cape-dict t)))
    ;;   )
    ;; (add-hook 'org-msg-edit-mode-hook #'weiss-set-org-msg-edit-mode-capfs)
    ;; (remove-hook 'org-msg-edit-mode-hook #'weiss-set-org-msg-edit-mode-capfs)
    )

  (with-eval-after-load 'eglot
    ;; (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
    (advice-add 'eglot-completion-at-point :around #'cape-wrap-case-fold)

    (setq-mode-local
     scala-mode
     completion-at-point-functions
     '(eglot-completion-at-point t))
    )

  (setq cape-dabbrev-min-length 5)
  )

(provide 'weiss_cape_settings)
