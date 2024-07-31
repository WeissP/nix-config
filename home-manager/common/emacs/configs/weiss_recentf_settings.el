(recentf-mode 1)
(with-eval-after-load 'recentf
  ;; (recentf-mode 1)
  ;; (message "recentf loaded!")
  ;; (load (weiss--get-config-file-path "recentf"))
  ;; (setq recentf-save-file (weiss--get-config-file-path "recentf"))
  
  (defun weiss-update-recentf ()
    "DOCSTRING"
    (interactive)
    (let ((message-log-max nil))
      (recentf-save-list)
      (recentf-cleanup)
      ))
  (run-at-time nil 60 'recentf-save-list)
  
  (setq
   recentf-max-menu-items 150
   recentf-max-saved-items 3000
   ;; recentf-auto-cleanup '60
   ;; Recentf blacklist
   recentf-exclude `(
                     ,(rx "*message*")
                     ".*autosave$"
                     ;; "/ssh:"
                     ;; "/sudo:"
                     "recentf$"
                     ".*archive$"
                     ".*.jpg$"
                     ".*.png$"
                     ".*.gif$"
                     ".*.mp4$"
                     ".cache"
                     "cache"
                     "<none>.tex"
                     "frag-master.tex"
                     "_region_.tex"
                     "COMMIT_EDITMSG\\'"
                     ))
  ;; (load (weiss--get-config-file-path "recentf"))
  )

(provide 'weiss_recentf_settings)
