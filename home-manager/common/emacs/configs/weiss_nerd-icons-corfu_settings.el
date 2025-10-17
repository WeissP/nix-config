(with-eval-after-load 'nerd-icons-corfu
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)
  (setq nerd-icons-corfu-mapping 
        (-snoc nerd-icons-corfu-mapping '(t :style "cod" :icon "gear" :face font-lock-type-face) ))
  )

(provide 'weiss_nerd-icons-corfu_settings)
