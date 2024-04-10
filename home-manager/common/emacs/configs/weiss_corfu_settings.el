(setq
 corfu-cycle t
 corfu-auto t
 corfu-auto-prefix 2
 corfu-auto-delay 0.1
 corfu-preselect 'prompt
 )

(with-eval-after-load 'corfu
  (global-corfu-mode)
  ;; (add-hook 'text-mode-hook #'corfu-mode)
  (add-to-list 'corfu-auto-commands 'backward-delete-char-untabify)
  (add-to-list 'corfu-auto-commands 'wks-vanilla-mode-enable)
  (add-to-list 'corfu-auto-commands 'delete-backward-char)
  (with-eval-after-load 'markdown-mode
    (add-to-list 'corfu-auto-commands 'markdown-outdent-or-delete)
    )

  (with-eval-after-load 'eglot
    (setq completion-category-overrides '((eglot (styles orderless))))
    )

  (require 'corfu-popupinfo)
  (corfu-popupinfo-mode)
  )

(with-eval-after-load 'cape
  (with-eval-after-load 'org
    (setq-mode-local
     org-mode
     completion-at-point-functions '(pcomplete-completions-at-point cape-dict t))
    )

  (with-eval-after-load 'latex
    (setq-mode-local
     latex-mode
     completion-at-point-functions
     '(TeX--completion-at-point LaTeX--arguments-completion-at-point cape-dict t))
    )

  (with-eval-after-load 'mind-wave
    (setq-mode-local
     mind-wave-chat-mode
     completion-at-point-functions '(cape-dict t))
    )

  )

(provide 'weiss_corfu_settings)
