(define-prefix-command 'wks-global-quick-insert-keymap)

(defun weiss--generate-insert-pair-alist (new-line pairs)
  "DOCSTRING"
  (interactive)
  (require 'dash)
  (-flatten
   (mapcar (lambda (item)
             (let ((pair (car item))
                   (keys (cdr item))
                   )              
               (mapcar (lambda (key) `(,key . ,(intern
                                                (format "weiss-insert-%s%s"
                                                        pair
                                                        (if new-line "-newline" "" )
                                                        ))))
                       keys
                       )
               ))
           pairs))  
  )

(setq weiss--common-pair-alist
      '(("paren" . ("j" "("))
        ("bracket" . ("k" "["))
        ("brace" . ("l" "{"))
        ("double-quotes" . ("i" "\""))
        ("single-quote" . ("o"))
        ("underline" . ("-" "_"))
        ("wavy" . ("~"))
        ("equals" . ("="))
        ("bar" . ("a" "&"))
        ("backquote" . ("q"))
        ("elisp-quote" . ("w"))
        ("star" . ("s"))
        ("slash" . ("/"))
        ("dollar" . ("$"))
        ("and" . ("7"))
        ("angle-bracket" . ("m" "<"))
        ("backslash" . ("<deletechar>"))
        ("norm" . ("n"))
        ))

(setq weiss--escape-pair-alist
      '(("escape-paren" . ("j" "("))
        ("escape-bracket" . ("k" "["))
        ("escape-brace" . ("l" "{"))
        ("escape-double-quotes" . ("i" "\""))
        ("escape-single-quote" . ("o"))
        ))


(wks-define-key  wks-global-quick-insert-keymap ""
                 (weiss--generate-insert-pair-alist nil weiss--common-pair-alist))

(wks-define-key  wks-global-quick-insert-keymap ""
                 '(("RET" . (weiss-insert-new-line (insert "\\n")))))
(wks-define-key  wks-global-quick-insert-keymap ""
                 '(("c" . weiss-insert-markdown-quote-block-newline)))

(wks-define-key  wks-global-quick-insert-keymap "e "
                 (weiss--generate-insert-pair-alist nil weiss--escape-pair-alist))

(wks-define-key  wks-global-quick-insert-keymap "<end> "
                 (weiss--generate-insert-pair-alist t weiss--common-pair-alist))

(wks-define-key  wks-global-quick-insert-keymap "<end> e "
                 (weiss--generate-insert-pair-alist t weiss--escape-pair-alist))


;; parent: 
(provide 'weiss_wks_quick-insert)
