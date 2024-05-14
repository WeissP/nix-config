(define-prefix-command 'wks-consult-multi-keymap)

(wks-define-key
 wks-prompt-keymap
 ""
 '(
   ("n" . weiss-denote-consult)
   ("d" . consult-fd)
   ("m" . wks-consult-multi-keymap)
   ("r" . consult-ripgrep)
   ))

(wks-define-key
 (current-global-map)
 ""
 '(
   ("n" . consult-line)
   ("s" . consult-buffer)
   ))

(with-eval-after-load 'dired
  (wks-define-key
   dired-mode-map
   ""
   '(
     ("n" . consult-line)
     ("s" . consult-buffer)
     ))
  )

(wks-define-key
 wks-consult-multi-keymap  ""
 '(
   ("i" .  consult-imenu-multi)
   )
 )

(define-key (current-global-map) [remap yank-pop] 'consult-yank-pop)
(define-key (current-global-map) [remap imenu] 'consult-imenu)
(define-key (current-global-map) [remap goto-line] 'consult-goto-line)

(with-eval-after-load 'org
  (define-key org-mode-map [remap imenu] 'consult-org-heading)
  )

(with-eval-after-load 'consult
  (setq consult-narrow-key "<f5>")
  )


(provide 'weiss_consult_keybindings)
