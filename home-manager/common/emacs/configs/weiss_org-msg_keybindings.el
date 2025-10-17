(with-eval-after-load 'org-msg
  (wks-define-key
   org-msg-edit-mode-map ""
   '(
     ("C-c C-a" . org-msg-attach)
     ))
  )

(provide 'weiss_org-msg_keybindings)
