(wks-define-key
 (current-global-map)
 ""
 '(
   ("C-v" . embark-act)
   ))

(wks-define-key
 wks-leader-keymap
 ""
 '(
   ("C-v" . embark-dwim)
   ))

(with-eval-after-load 'embark
  (setq embark-help-key "?")
  
  (wks-define-key
   embark-file-map
   ""
   '(
     ("n" . weiss-embark-copy-file-name)
     ))

  (wks-define-key
   embark-symbol-map
   ""
   '(
     ("l" . embark-toggle-highlight)
     ("c" . weiss-upcase-initials-region)
     ("<up>" . weiss-upcase-region)
     ("<down>" . weiss-downcase-region)
     ))

  (wks-define-key
   embark-command-map
   ""
   '(
     ("l" . embark-toggle-highlight)
     ("c" . weiss-upcase-initials-region)
     ("<up>" . weiss-upcase-region)
     ("<down>" . weiss-downcase-region)
     ))

  (wks-define-key
   embark-variable-map
   ""
   '(
     ("l" . embark-toggle-highlight)
     ("c" . weiss-upcase-initials-region)
     ("<up>" . weiss-upcase-region)
     ("<down>" . weiss-downcase-region)
     ))

  (with-eval-after-load 'org
    (wks-define-key
     embark-org-heading-map
     ""
     '(
       ("i" . org-clock-in)
       ("o" . org-clock-out)
       ("r" . org-clock-report)
       ("w" . embark-copy-as-kill)
       ))
    )
  

  ;; (wks-define-key
  ;;  minibuffer-local-completion-map
  ;;  ""
  ;;  '(("TAB" . minibuffer-force-complete)
  ;;    ("<down>" . minibuffer-force-complete)
  ;;    ("C-M-S-s-j" . toggle-between-minibuffer-and-embark-collect-completions)
  ;;    ("DEL" . minibuffer-directory-up)))
  )

;; parent: 
(provide 'weiss_embark_keybindings)
