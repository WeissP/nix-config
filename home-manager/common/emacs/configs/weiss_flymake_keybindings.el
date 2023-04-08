(wks-define-key
 (current-global-map)
 ""
 '(
   ("C-c C-f" . weiss-flymake-dwim)
   ("y <down>" . flymake-goto-next-error)
   ("y <up>" . flymake-goto-prev-error)
   ))

(provide 'weiss_flymake_keybindings)
