(with-eval-after-load 'citre
  (setq
   citre-completion-case-sensitive nil
   ;; citre-project-root-function #'projectile-project-root
   citre-project-root-function #'citre--project-root
   citre-enable-xref-integration t 
   )
  (add-hook 'find-file-hook #'weiss-enable-annotate-mode)
  )

;; parent: 
(provide 'weiss_citre_settings)
