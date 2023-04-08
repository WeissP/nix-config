(wks-define-key
 (current-global-map)
 ""
 '(("n" . consult-line)
   ))

(wks-define-key
 wks-leader-keymap  ""
 '(
   ("i f" .  consult-find)
   ("i v" .  consult-yank-pop)
   ("i i" .  consult-imenu)
   ("i m i" .  consult-imenu-multi)

   ("k l" .  consult-goto-line)
   )
 )

;; not work in org-noter
;; (with-eval-after-load 'org
;;   (define-key org-mode-map [remap consult-imenu] 'consult-org-heading)
;; )

(with-eval-after-load 'consult
  (setq consult-narrow-key "<f5>")
)
(defun weiss-test ()
  "DOCSTRING"
  (interactive)
  (consult-buffer))

(provide 'weiss_consult_keybindings)
