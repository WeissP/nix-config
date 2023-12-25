(with-eval-after-load 'sideline
  (setq sideline-display-backend-name t)
  (setq sideline-backends-right-skip-current-line nil)
  (setq sideline-backends-right '(sideline-eldoc))
  )

(provide 'weiss_sideline_settings)
