(with-eval-after-load 'cider-mode
  ;; resolve the conflict between lsp and cider
  (add-hook 'cider-mode-hook
            (lambda ()
              (add-to-list 'minor-mode-overriding-map-alist
                           (assoc 'cider-mode minor-mode-map-alist))))

  (define-key cider-mode-map [remap weiss-eval-last-sexp-this-line] 'weiss-cider-eval-last-sexp-this-line)
  (define-key cider-mode-map [remap eval-defun] 'cider-eval-defun-at-point)
  (define-key cider-mode-map [remap weiss-execute-buffer] 'cider-eval-buffer)
  (define-key cider-mode-map [remap eval-region] 'cider-eval-region)
  (define-key cider-mode-map [remap xref-find-definitions] 'cider-find-var)
  
  (wks-unset-key cider-mode-map '("C-c C-f" "C-c C-p"))
  (wks-define-key
   cider-mode-map
   ""
   `(("C-c C-c" . cider-interrupt)
     ("C-c C-j" . cider-jack-in)
     ("y -" . weiss-cider-save-and-load)
     ("C-c C-b" . cider-pop-back)
     ("C-c C-SPC" . cider-inspect-last-result)
     ("C-c C-M-x <f5>" . weiss-cider-true-restart)
     ("C-c C-M-x c" . weiss-cider-connect-babashka)
     ("C-c C-M-x s" . cider-connect-cljs)
     ("C-c C-M-x f" . re-frame-jump-to-reg)
     ("C-c C-M-x x" . cider-run)
     ;; ("C-c C-SPC c" . weiss-add-colon)
     ("SPC , i" . cider-eval-last-sexp-to-repl)
     ("SPC , p" . cider-eval-list-at-point)
     ("SPC , f" . cider-eval-defun-at-point)))

  (wks-unset-key cider-repl-mode-map '(","))
  (wks-define-key
   cider-repl-mode-map
   ""
   '(;; cider-repl-backward-input
     ("<up>" . cider-repl-previous-input)
     ("<down>" . cider-repl-next-input)))

  (wks-unset-key cider-stacktrace-mode-map '("j" "a"))
  (wks-define-key
   cider-stacktrace-mode-map
   ""
   '(("J" . cider-stacktrace-toggle-java)))

  (wks-unset-key cider-docview-mode-map '("j"))
  (wks-define-key
   cider-docview-mode-map
   ""
   '(("J" . cider-stacktrace-toggle-java)))

  (wks-unset-key cider-inspector-mode-map '("l" "a"))
  (wks-define-key
   cider-inspector-mode-map
   ""
   '(("p" . cider-inspector-pop)))

  (with-eval-after-load 'embark
    (wks-define-key
     embark-expression-map 
     ""
     '(
       ("p" . weiss-cider-embark-pprint)
       ))
    )
  )

;; parent: 
(provide 'weiss_cider_keybindings)
