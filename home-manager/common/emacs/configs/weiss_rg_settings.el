(with-eval-after-load 'rg
  (setq
   rg-executable (executable-find "rg")
   ;; rg-command-line-flags '("-L")        ; follow symlinks
   rg-command-line-flags nil
   rg-ignore-ripgreprc nil
   )
  )

(provide 'weiss_rg_settings)
