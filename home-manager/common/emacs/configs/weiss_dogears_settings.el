(add-hook 'prog-mode-hook #'dogears-mode)
(with-eval-after-load 'dogears
  (advice-add 'beginning-of-buffer :before #'dogears-remember)
  (advice-add 'end-of-buffer :before #'dogears-remember)
  (add-to-list 'dogears-hooks 'xref-after-jump-hook)
  (setq dogears-functions '()
        dogears-idle 100)  
  )

(provide 'weiss_dogears_settings)
