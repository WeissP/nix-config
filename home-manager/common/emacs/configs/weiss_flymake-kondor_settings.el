(with-eval-after-load 'clojure-mode
  (add-hook 'clojure-mode-hook #'flymake-mode)
  ;; (add-hook 'clojure-mode-hook #'flymake-kondor-setup)
  )

(provide 'weiss_flymake-kondor_settings)
