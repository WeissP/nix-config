(with-eval-after-load 'nerd-icons-dired
  (add-hook 'dired-mode-hook (lambda () 
                               (when (weiss-show-icons-in-dired-p)
                                 (nerd-icons-dired-mode)
                                 )
                               ))
  )

(provide 'weiss_nerd-icons-dired_settings)
