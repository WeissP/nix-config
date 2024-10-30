(wks-define-key
 (current-global-map)
 ""
 '(
   ("C-c RET" . gptel-send)
   ("SPC d c" .  gptel)
   ))
(wks-unset-key org-mode-map '("C-c RET"))

(provide 'weiss_gptel_keybindings)
