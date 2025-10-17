(with-eval-after-load 'scala-mode
  (add-to-list 'auto-mode-alist '("\\.sc\\'" . scala-mode))
  (add-to-list 'auto-mode-alist '("\\.mill\\'" . scala-mode))
  (require 'scala-cli-repl)
  )

(provide 'weiss_scala-mode_settings)
