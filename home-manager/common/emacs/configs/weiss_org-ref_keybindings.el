(with-eval-after-load 'org
  (wks-define-key
   org-mode-map ""
   '(
     ("C-c C-M-x c" . weiss-org-ref-insert-labels))))

(provide 'weiss_org-ref_keybindings)
