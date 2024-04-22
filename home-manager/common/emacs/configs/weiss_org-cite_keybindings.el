(with-eval-after-load 'org
  (wks-define-key
   org-mode-map
   "SPC <end>"
   '(
     ("i" . org-cite-insert)
     ))
  )

(provide 'weiss_org-cite_keybindings)
