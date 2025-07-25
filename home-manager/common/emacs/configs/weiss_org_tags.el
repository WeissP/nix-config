(defun weiss-set-org-tags (&optional arg)
    "set tags with counsel, using org-use-fast-tag-selection if `arg' =4, align tags if `arg' = 16"
    (interactive "P")
    ;; deactivate mark for org-set-tags-command
    (deactivate-mark)
    (pcase arg
      ('(4) (counsel-org-tag))
      ('(16) (org-align-tags t))
      (_ (let ((current-prefix-arg 4))
           (call-interactively 'org-set-tags-command)       
           ))
      )  
    )

(with-eval-after-load 'org
  (setq
   org-tag-alist '(("noexport" . ?n))
   org-tags-column -80
   org-fast-tag-selection-single-key t
   )
  )

;; parent: 
(provide 'weiss_org_tags)
