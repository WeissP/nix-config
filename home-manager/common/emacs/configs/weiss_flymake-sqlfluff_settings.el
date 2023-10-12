(require 'flymake-sqlfluff)
(with-eval-after-load 'flymake-sqlfluff
  (add-hook 'sql-mode-hook #'flymake-mode)
  (add-hook 'sql-mode-hook #'flymake-sqlfluff-load)
  )

(provide 'weiss_flymake-sqlfluff_settings)
