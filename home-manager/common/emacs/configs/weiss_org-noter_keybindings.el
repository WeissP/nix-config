(with-eval-after-load 'org-noter
  (wks-unset-key org-noter-doc-mode-map '("i"))
  (define-key org-noter-notes-mode-map [remap xref-find-definitions] #'org-noter-sync-current-note)
  (wks-define-key
   org-noter-doc-mode-map
   ""
   '(
     ("x" . org-noter-insert-precise-note-toggle-no-questions)
     ))
  )

(provide 'weiss_org-noter_keybindings)
