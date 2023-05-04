(with-eval-after-load 'markdown-mode
  (wks-define-key
   markdown-mode-map ""
   '(
     ("t" . markdown-toggle-inline-images)
     )
   )
  )

(provide 'weiss_markdown-mode_keybindings)
