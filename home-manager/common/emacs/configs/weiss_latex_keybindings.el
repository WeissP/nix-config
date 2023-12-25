;; (with-eval-after-load 'tex-mode
;;   (wks-unset-key latex-mode-map '("$" "_"))

;;   (wks-define-key
;;    latex-mode-map ""
;;    '(("<escape> <escape>" . wks-latex-quick-insert-keymap)
;;      ("<tab>" . weiss-indent)
;;      ("t" . weiss-latex-to-pdf)
;;      ("<RET>" . weiss-deactivate-mark-and-new-line))
;;    )
;;   (wks-unset-key latex-mode-map '("$" "_"))

;;   (wks-define-key
;;    LaTeX-mode-map ""
;;    '(("<escape> <escape>" . wks-latex-quick-insert-keymap)
;;      ("<tab>" . weiss-indent)
;;      ("t" . weiss-latex-to-pdf)
;;      ("C-c C-M-x r" . reftex-reference)
;;      ("<RET>" . weiss-deactivate-mark-and-new-line))
;;    ))

(with-eval-after-load 'latex   
  (wks-unset-key LaTeX-mode-map '("$" "_" "^" "(" "{" "["))

  (wks-define-key
   LaTeX-mode-map ""
   '(("<end> <escape>" . wks-latex-quick-insert-keymap)
     ("<tab>" . save-buffer)
     ("t" . weiss-latex-to-pdf)
     ("C-c C-M-x r" . reftex-reference)
     ("<RET>" . weiss-deactivate-mark-and-new-line)
     ("C-c C-SPC" . TeX-next-error))
   )
  )

(provide 'weiss_latex_keybindings)
