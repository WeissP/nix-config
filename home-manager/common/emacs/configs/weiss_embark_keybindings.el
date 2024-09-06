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
  
  (with-eval-after-load 'eglot
    (define-key eglot-mode-map [remap display-local-help] #'eldoc))

  (wks-define-key
   embark-general-map
   ""
   '(
     ("d" . fanyi-dwim)
     ))

  (wks-define-key
   embark-file-map
   ""
   '(
     ("d" . fanyi-dwim)
     ("n" . weiss-embark-copy-file-name)
     ("s" . sudo-edit)
     ("vlf" . vlf)
     ))

  (wks-define-key
   embark-symbol-map
   ""
   '(
     ("d" . fanyi-dwim)
     ("l" . embark-toggle-highlight)
     ("c" . weiss-capitalize-region)
     ("<up>" . weiss-upcase-region)
     ("<down>" . weiss-downcase-region)
     ))

  (wks-define-key
   embark-region-map
   ""
   '(
     ("s" . weiss-subscriptify-region)
     ("d" . fanyi-dwim)
     ("e" . weiss-embark-eval-and-output-region)
     ("-" . weiss-add-dashs)
     ("_" . xah-cycle-hyphen-underscore-space)
     ("l" . embark-toggle-highlight)
     ("c" . weiss-capitalize-region)
     ("f" . xah-fill-or-unfill)
     ("o" . occur)
     ("<up>" . weiss-upcase-region)
     ("<down>" . weiss-downcase-region)
     ))

  (wks-define-key
   embark-paragraph-map
   ""
   '(
     ("_" . xah-cycle-hyphen-underscore-space)
     ("f" . xah-fill-or-unfill)
     ))

  (wks-define-key
   embark-sentence-map
   ""
   '(
     ("_" . xah-cycle-hyphen-underscore-space)
     ("f" . xah-fill-or-unfill)
     ))

  (wks-define-key
   embark-defun-map
   ""
   '(
     ("<up>" . puni-slurp-forward)
     ("<down>" . weiss-add-parent-sexp)
     ("<" . weiss-delete-parent-sexp)
     ))

  (wks-define-key
   embark-expression-map
   ""
   '(
     ("<up>" . puni-slurp-forward)
     ("<down>" . weiss-add-parent-sexp)
     ("<" . weiss-delete-parent-sexp)
     ))

  (wks-define-key
   embark-command-map
   ""
   '(
     ("d" . fanyi-dwim)
     ("l" . embark-toggle-highlight)
     ("c" . weiss-capitalize-region)
     ("<up>" . weiss-upcase-region)
     ("<down>" . weiss-downcase-region)
     ))

  (wks-define-key
   embark-identifier-map
   ""
   '(
     ("d" . fanyi-dwim)
     ("l" . embark-toggle-highlight)
     ("c" . weiss-capitalize-region)
     ("<up>" . weiss-upcase-region)
     ("<down>" . weiss-downcase-region)
     ))

  (wks-define-key
   embark-variable-map
   ""
   '(
     ("d" . fanyi-dwim)
     ("l" . embark-toggle-highlight)
     ("c" . weiss-capitalize-region)
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
