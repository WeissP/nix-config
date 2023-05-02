;; apheleia-global-mode autoloads has something wrong with nix pkgs
(require 'apheleia-core)
(apheleia-global-mode)
(with-eval-after-load 'apheleia
  (push '(zprint . ("zprint")) apheleia-formatters)    
  (push '(xmlstarlet . ("xmlstarlet" "format" "--indent-tab")) apheleia-formatters)    
  (push '(rustfmt . ("rustfmt" "+nightly" "--quiet" "--emit" "stdout")) apheleia-formatters)
  (push '(clojurescript-mode . zprint) apheleia-mode-alist)
  (push '(clojure-mode . zprint) apheleia-mode-alist)
  (push '(nxml-mode . xmlstarlet) apheleia-mode-alist)
  )

(provide 'weiss_apheleia_settings)
