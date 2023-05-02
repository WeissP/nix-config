(with-eval-after-load 'rg
  (setq
   rg-executable (executable-find "rg")
   rg-command-line-flags '("-L")        ; follow symlinks
   )
  
  )

(provide 'weiss_rg_settings)
