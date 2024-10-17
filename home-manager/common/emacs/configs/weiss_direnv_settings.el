(with-eval-after-load 'direnv
  (direnv-mode)
  (setq direnv-always-show-summary nil)
  )

(add-to-list 'warning-suppress-types '(direnv))

(provide 'weiss_direnv_settings)
