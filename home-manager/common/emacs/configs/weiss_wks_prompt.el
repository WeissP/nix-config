(defvar wks-prompt-keymap (make-keymap "wks prompt"))
(define-prefix-command 'wks-prompt-keymap-command 'wks-prompt-keymap)

(wks-define-key
 (current-global-map)
 ""
 '(
   ("h" . wks-prompt-keymap-command)
   ))

(with-eval-after-load 'dired
  (wks-define-key
   dired-mode-map
   ""
   '(
     ("h" . wks-prompt-keymap-command)
     ))
  )


(wks-define-key
 wks-prompt-keymap
 ""
 '(
   ("x" . execute-extended-command)
   ("f" . find-file)
   ("v" . yank-pop)
   ("e" . emoji-insert)
   ("i" . imenu)
   ("l" . goto-line)
   ))

(provide 'weiss_wks_prompt)
