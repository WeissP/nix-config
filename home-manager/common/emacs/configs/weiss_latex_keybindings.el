(with-eval-after-load 'latex   
  (wks-unset-key LaTeX-mode-map '("$" "_" "^" "(" "{" "[" "-"))

  (wks-define-key
   LaTeX-mode-map ""
   '(("<end> <escape>" . quick-insert-insert-latex)
     ("t" . quick-insert-insert-latex)
     ("<tab>" . save-buffer)
     ("C-c C-M-x r" . reftex-reference)
     ("C-c C-M-x c" . weiss-latex-to-pdf)
     ("<RET>" . weiss-deactivate-mark-and-new-line)
     ("C-c C-SPC" . TeX-next-error))
   )
  )

(with-eval-after-load 'latex-preview-pane
  (wks-unset-key latex-preview-pane-mode-map '("t"))
  )

(provide 'weiss_latex_keybindings)
