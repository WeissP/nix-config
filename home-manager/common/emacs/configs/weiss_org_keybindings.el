(wks-define-key
 (current-global-map)
 "SPC "
 '(("d a" .  weiss-custom-daily-agenda)
   ("d t" .  org-todo-list)))

(defvar wks-org-extra-keymap (make-keymap "wks org extra keymap"))
(define-prefix-command 'wks-org-extra-keymap-command 'wks-org-extra-keymap)

(with-eval-after-load 'org
  
  (defun weiss-org-return ()
    "DOCSTRING"
    (interactive)
    (deactivate-mark)
    (call-interactively 'org-return))

  (wks-unset-key org-mode-map '("C-c C-j"))

  (wks-define-key
   org-mode-map ""
   '(("M-i" . org-shiftmetaleft)
     ("M-k" . org-metaup)
     ("M-j" . org-metadown)
     ("M-l" . org-shiftmetaright)
     ("M-o" . org-metaleft)
     ("M-p" . org-metaright)
     ("RET" . weiss-org-return)
     ("<return>" . weiss-org-return)

     ("<shifttab>" . org-shifttab)
     ;; ("-" . +org/dwim-at-point)
     (";" . org-meta-return)
     ("\\" . +org/dwim-at-point)
     ;; ("$" . org-export-dispatch)
     ;; ("C" . org-copy-subtree)
     ("d" . weiss-org-cut-line-or-delete-region)
     ("j" . (weiss-org-next-line (next-line) (deactivate-mark)))
     ("k" . (weiss-org-previous-line (previous-line) (deactivate-mark)))
     ("t" . weiss-org-preview-or-latex-quick-insert)
     ("x" . weiss-org-exchange-point-or-switch-to-sp)
     ("X" . org-refile)

     ("C-c C-a" . weiss-org-screenshot)
     ("C-c C-M-x i" . weiss-org-insert-pdf-link)
     ("C-c C-M-x e" . weiss-org-export-to-pdf)
     ("C-c C-M-x f" . weiss-org-insert-image)
     ("C-c C-M-x u" . weiss-check-umlaut)
     ("C-c C-M-x t" . org-babel-tangle)
     ("C-c C-M-x l" . weiss-insert-org-transclusion)
     ("C-c C-SPC" . TeX-next-error)
     ("C-c C-o" . org-noter)
     ("y d" . weiss-org-download-img)
     ("y g" . org-goto)
     ("C-c C-q" . weiss-set-org-tags)
     ("C-c C-s" . org-store-link)
     ("C-c C-t" . org-todo)
     ("C-c C-b" . org-mark-ring-goto)
     ;; ("y <tab>" . org-table-create-with-table\.el)
     ("y <tab>" . org-table-toggle-column-width)
     ("y j s" . weiss-org-copy-heading-link)
     ;; ("C-c C-j e" . (weiss-emoji-insert (emoji-insert) (wks-vanilla-mode-enable)))
     ("C-c C-j" . wks-org-extra-keymap-command)
     ;; ("<f5>" . org-beamer-export-to-pdf)

     ("<end> <escape>" . (quick-insert-insert-org (quick-insert-consult "org source code")))))

  (wks-define-key
   wks-org-extra-keymap
   ""
   '(
     ("e" . emoji-insert)
     ))
  )

(with-eval-after-load 'org-agenda
  (wks-unset-key org-agenda-mode-map '("9" "-" "SPC"))
  (wks-define-key
   org-agenda-mode-map ""
   '(("-" . xah-backward-punct)
     ("=" . xah-forward-punct)))

  (fset 'org-agenda-done "td"))

(provide 'weiss_org_keybindings)
