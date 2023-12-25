(with-eval-after-load 'eldoc-box
  ;; (setq eldoc-box-only-multi-line t)
  (setq eldoc-idle-delay 1)
  (with-eval-after-load 'eglot
    (add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-mode t)
    )
  )

(provide 'weiss_eldoc-box_settings)
