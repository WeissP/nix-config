(apheleia-global-mode +1)
(with-eval-after-load 'apheleia
  (push '(zprint . ("zprint")) apheleia-formatters)
  (push '(clojurescript-mode . zprint) apheleia-mode-alist)
  (push '(clojure-mode . zprint) apheleia-mode-alist)
  )

(provide 'weiss_apheleia_settings)
