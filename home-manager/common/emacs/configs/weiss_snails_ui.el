(with-eval-after-load 'snails
  (defun snails-render-web-icon ()
    (all-the-icons-faicon "globe"))

  (with-no-warnings
    (advice-add 'snails-init-face-with-theme :override 'ignore)
    )
  )

;; parent: 
(provide 'weiss_snails_ui)
