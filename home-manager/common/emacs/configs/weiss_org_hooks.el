(add-hook 'org-indent-mode-hook
          (lambda()
            ;; WORKAROUND: Prevent text moving around while using brackets
            ;; @see https://github.com/seagle0128/.emacs.d/issues/88
            (make-variable-buffer-local 'show-paren-mode)
            (setq show-paren-mode nil)))

(add-hook 'org-mode-hook
          (lambda ()
            (visual-line-mode)
            (eldoc-mode -1)
            ))

(provide 'weiss_org_hooks)
