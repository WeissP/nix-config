(add-to-list 'completion-at-point-functions #'cape-dabbrev)
(add-to-list 'completion-at-point-functions #'cape-file)
(add-to-list 'completion-at-point-functions #'cape-elisp-block)

(with-eval-after-load 'cape
  (with-eval-after-load 'eglot
    (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
    (advice-add 'eglot-completion-at-point :around #'cape-wrap-case-fold)

    (setq-mode-local
     scala-mode
     completion-at-point-functions
     '(eglot-completion-at-point t))
    )

  (setq cape-dabbrev-min-length 5)
  )

(provide 'weiss_cape_settings)
