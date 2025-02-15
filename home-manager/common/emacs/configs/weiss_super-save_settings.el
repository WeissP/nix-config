(with-eval-after-load 'super-save
  (add-to-list 'super-save-triggers 'find-file)
  (add-to-list 'super-save-triggers 'org-edit-special)
  (add-to-list 'super-save-triggers 'other-frame)
  (add-to-list 'super-save-triggers 'select-frame-set-input-focus)
  (add-to-list 'super-save-triggers 'dired-jump)
  (super-save-mode +1)

  (with-eval-after-load 'aider 
    (advice-add 'aider-transient-menu :before #'super-save-command-advice)
    )
  )

;; parent: 
(provide 'weiss_super-save_settings)
