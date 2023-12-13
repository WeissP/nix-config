(setq
 corfu-cycle t
 corfu-auto t
 )

(with-eval-after-load 'corfu
  (global-corfu-mode)
  (setq completion-category-overrides '((eglot (styles orderless))))
  )

(with-eval-after-load 'cape
  (with-eval-after-load 'org
    (setq-mode-local org-mode
                     completion-at-point-functions '(cape-dabbrev pcomplete-completions-at-point cape-dict t))
    )
  )

(provide 'weiss_corfu_settings)
