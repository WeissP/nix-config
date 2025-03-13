(with-eval-after-load 'org
  (wks-define-key
   org-mode-map ""
   '(
     ("C-c C-M-x c" . org-ref-insert-ref-function))))
 
(provide 'weiss_org-ref_keybindings)
