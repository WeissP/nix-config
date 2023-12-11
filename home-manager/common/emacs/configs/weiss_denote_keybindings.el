(with-eval-after-load 'denote
  (wks-define-key
   (current-global-map)
   ""
   '(
     ("2" . weiss-denote-consult)
     ))

  (wks-define-key
   wks-leader-keymap
   "e "
   '(
     ("r" . denote-rename-file-using-front-matter)
     ("j" . denote-journal-extras-new-entry)
     ))

  (wks-define-key
   dired-mode-map ""
   '(
     ("e" . denote-dired-rename-files)
     ("x" . denote-dired-rename-marked-files-with-keywords)
     )
   )
  
  (with-eval-after-load 'pdf-view
    (wks-define-key
     pdf-view-mode-map ""
     '(
       ("d" . weiss-denote-pdf-note)
       )
     )
    )
  
  (with-eval-after-load 'org
    (wks-define-key
     org-mode-map "C-c "
     '(("C-i" . weiss-denote-consult-link-notes)
       ("C-j t" . denote-keywords-add)
       ("C-r" . weiss-denote-org-extract-subtree)
       ))
    )

  (with-eval-after-load 'nov
    (wks-define-key
     nov-mode-map ""
     '(("d" . weiss-denote-consult)
       ))
    )

  )


(provide 'weiss_denote_keybindings)
