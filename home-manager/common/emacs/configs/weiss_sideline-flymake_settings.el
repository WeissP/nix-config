(with-eval-after-load 'sideline-flymake
  (setq sideline-flymake-display-mode 'line)
  (setq sideline-flymake-show-backend-name t)
  (setq sideline-backends-right '(sideline-flymake))
  )

(provide 'weiss_sideline-flymake_settings)
