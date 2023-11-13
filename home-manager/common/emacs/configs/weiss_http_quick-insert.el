(define-prefix-command 'wks-http-quick-insert-keymap)

(weiss-insert-pair-macro "http-b" "<b>" "</b>")
(weiss-insert-pair-macro "http-i" "<i>" "</i>")
(weiss-insert-pair-macro "http-u" "<u>" "</u>")
(weiss-insert-pair-macro "http-p" "<p>" "</p>")
(weiss-insert-pair-macro "http-li" "<li>" "</li>")
(weiss-insert-pair-macro "http-span" "<span>" "</span>")
(weiss-insert-pair-macro "http-div" "<div>" "</div>")

(setq weiss--http-pair-alist
      '(("http-b" . ("b"))
        ("http-i" . ("i"))
        ("http-u" . ("u"))
        ("http-p" . ("p"))
        ("http-li" . ("l"))
        ("http-span" . ("s"))
        ("http-div" . ("d"))
        )
      )

(wks-define-key  wks-http-quick-insert-keymap ""
                 (weiss--generate-insert-pair-alist nil weiss--http-pair-alist)
                 )


(wks-define-key  wks-http-quick-insert-keymap "<end> "
                 (weiss--generate-insert-pair-alist t weiss--http-pair-alist)
                 )



;; parent: 
(provide 'weiss_http_quick-insert)
