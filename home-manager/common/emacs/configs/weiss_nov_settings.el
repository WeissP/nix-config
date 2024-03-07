(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(with-eval-after-load 'nov
  
  (defun weiss-nov-setup ()
    "DOCSTRING"
    (interactive)
    (setq nov-text-width t)
    ;; (set-background-color "#f8fd80")
    ;; (set-background-color "#eddd6e")
    ;; (set-background-color "#edd1b0")
    ;; (set-background-color "beige")
    (face-remap-add-relative 'variable-pitch :height 150)
    (setq line-spacing 10)
    ;; (visual-line-mode -1)
    (visual-line-mode 1)
    (visual-fill-column-mode 1)

    (setq visual-fill-column-center-text t)
    (setq visual-fill-column-width (floor (/ (window-total-width) 1.2)))
    )

  (add-hook 'nov-mode-hook 'weiss-nov-setup)
  )

(provide 'weiss_nov_settings)
