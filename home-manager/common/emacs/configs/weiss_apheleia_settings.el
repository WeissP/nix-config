(apheleia-global-mode)
(with-eval-after-load 'apheleia
  (push '(zprint . ("zprint")) apheleia-formatters)    
  (push '(xmlstarlet . ("xmlstarlet" "format" "--indent-tab")) apheleia-formatters)    
  (push '(rustfmt . ("rustfmt" "--quiet" "--emit" "stdout")) apheleia-formatters)
  (push '(fourmolu . ("fourmolu" "--stdin-input-file" ".")) apheleia-formatters)
  (push '(haskell-mode . fourmolu) apheleia-mode-alist)
  (push '(clojurescript-mode . zprint) apheleia-mode-alist)
  (push '(clojure-mode . zprint) apheleia-mode-alist)
  (push '(nxml-mode . xmlstarlet) apheleia-mode-alist)
  )

(provide 'weiss_apheleia_settings)
