;; copied from https://github.com/oliyh/re-jump.el
(defun re-frame-jump-to-reg ()
  (interactive)
  (let* ((kw (cider-symbol-at-point 'look-back))
         (ns-qualifier (and
                        (string-match "^:+\\(.+\\)/.+$" kw)
                        (match-string 1 kw)))
         (kw-ns (if ns-qualifier
                    (cider-resolve-alias (cider-current-ns) ns-qualifier)
                  (cider-current-ns)))
         (kw-to-find (concat "::" (replace-regexp-in-string "^:+\\(.+/\\)?" "" kw))))

    (when (and ns-qualifier (string= kw-ns (cider-current-ns)))
      (error "Could not resolve alias \"%s\" in %s" ns-qualifier (cider-current-ns)))

    (progn (cider-find-ns "-" kw-ns)
           (search-forward-regexp (concat "reg-[a-zA-Z-]*[ \\\n]+" kw-to-find) nil 'noerror))))

(with-eval-after-load 'cider
  (require 'cider-util)
  (require 'cider-resolve)
  (require 'cider-client)
  (require 'cider-common)
  (require 'cider-find)
  (require 'clojure-mode)


  )

(provide 'weiss_cider_reframe)
