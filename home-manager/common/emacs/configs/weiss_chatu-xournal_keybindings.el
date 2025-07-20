(with-eval-after-load 'chatu-xournal
  (with-eval-after-load 'org
    (wks-define-key
     org-mode-map
     ""
     '(
       ("C-c C-x o"  . weiss-xournal-open-or-new)     
       ))
    )
  )

(provide 'weiss_chatu-xournal_keybindings)
