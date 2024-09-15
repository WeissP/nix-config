(wks-define-key
 (current-global-map)
 ""
 '(
   ("C-c RET" . gptel-send)
   ("SPC d c" .  gptel)
   ))
(wks-unset-key org-mode-map '("C-c RET"))

(with-eval-after-load 'gptel-transient
  (transient-suffix-put 'gptel-menu (kbd "RET") :key "SPC")
  )

(provide 'weiss_gptel_keybindings)


