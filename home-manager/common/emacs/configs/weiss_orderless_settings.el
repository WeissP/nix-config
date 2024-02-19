(with-eval-after-load 'orderless
  (setq completion-ignore-case t)
  (setq completions-detailed t)

  (setq orderless-component-separator 'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-overrides '((file (styles basic partial-completion))))

  (setq orderless-matching-styles '(orderless-literal))
  (setq orderless-affix-dispatch-alist
        `((?! . ,#'orderless-without-literal)))
  )

;; parent: 
(provide 'weiss_orderless_settings)
