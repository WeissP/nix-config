(with-eval-after-load 'embark
  (add-to-list 'display-buffer-alist
               '("\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 (display-buffer-at-bottom)
                 (window-parameters .
                                    ((no-other-window . t)
                                     (mode-line-format . none)))))

  
  (setq embark-indicators
        '(embark-minimal-indicator  ; default is embark-mixed-indicator
          embark-highlight-indicator
          embark-isearch-highlight-indicator))

  (defun weiss-embark-copy-file-name (f)
    "DOCSTRING"
    (kill-new (f-filename f))
    )

  (with-eval-after-load 'vertico
    (require 'vertico-multiform)
    (add-to-list 'vertico-multiform-categories '(embark-keybinding grid))
    (vertico-multiform-mode)
    )

  (add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode)
  )

(provide 'weiss_embark_settings)
