(with-eval-after-load 'flymake-json
  (add-hook 'json-mode-hook 'flymake-json-load)
)

(provide 'weiss_flymake-json_settings)
