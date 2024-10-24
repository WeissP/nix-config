(with-eval-after-load 'aider
  (setq aider-args '("--config" "~/.config/aider/aider.conf.yml"))
  (advice-add
   'aider-run-aider
   :before #'(lambda (&rest args) (cd (project-root (project-current t))))
   )

  )



(provide 'weiss_aider_settings)
