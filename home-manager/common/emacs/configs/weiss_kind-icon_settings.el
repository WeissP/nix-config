(with-eval-after-load 'kind-icon
  (with-eval-after-load 'corfu
    (setq kind-icon-default-face 'corfu-default)
    (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
    )
  )

(provide 'weiss_kind-icon_settings)
