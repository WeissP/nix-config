(add-hook 'prog-mode-hook #'highlight-parentheses-mode)

(with-eval-after-load 'highlight-parentheses
  (setq hl-paren-highlight-adjacent t)
  )

;; parent: ui
(provide 'weiss_highlight-parentheses_settings)
