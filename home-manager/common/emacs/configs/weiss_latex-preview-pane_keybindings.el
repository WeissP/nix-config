(with-eval-after-load 'latex-preview-pane
  (wks-define-key LaTeX-mode-map ""
                  '(("C-c C-M-x l" . latex-preview-pane-mode)))
  )

(provide 'weiss_latex-preview-pane_keybindings)
