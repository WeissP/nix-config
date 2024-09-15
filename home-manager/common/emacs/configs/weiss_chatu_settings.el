(require 'chatu)
(require 'chatu-xournal)

(with-eval-after-load 'org
  (add-hook 'org-mode-hook #'chatu-mode)
  )

(with-eval-after-load 'chatu
  (advice-add 'chatu-add :before (lambda (&rest args) (save-buffer)))
  )

(provide 'weiss_chatu_settings)
