(with-eval-after-load 'markdown-mode
  (wks-unset-key markdown-mode-map '("`"))

  (wks-define-key
   markdown-mode-map ""
   '(
     ("t" . markdown-toggle-inline-images)
     )
   )
  )

(provide 'weiss_markdown-mode_keybindings)
