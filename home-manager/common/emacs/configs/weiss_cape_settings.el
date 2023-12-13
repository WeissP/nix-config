;; (add-to-list 'completion-at-point-functions #'cape-dabbrev)
(add-to-list 'completion-at-point-functions #'cape-file)
(add-to-list 'completion-at-point-functions #'cape-elisp-block)

(with-eval-after-load 'cape
  )

(provide 'weiss_cape_settings)
