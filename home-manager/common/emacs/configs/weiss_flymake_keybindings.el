(wks-define-key
 (current-global-map)
 ""
 '(
   ("C-c C-f" . consult-flymake)
   ("y <down>" . flymake-goto-next-error)
   ("y <up>" . flymake-goto-prev-error)
   ))

(provide 'weiss_flymake_keybindings)
