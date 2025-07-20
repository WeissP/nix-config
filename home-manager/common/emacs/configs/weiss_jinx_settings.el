(defun weiss-jinx--exclude-p (start)
  "DOCSTRING"
  (and
   (eq major-mode 'org-mode)
   (member
    (org-element-type (org-element-context (org-element-at-point start)))
    '(latex-fragment latex-environment))
   ))

(with-eval-after-load 'jinx
  (dolist (hook '(text-mode-hook conf-mode-hook))
    (add-hook hook #'jinx-mode))
  (setq jinx-languages "en de")

  ;; ignore all unicodes
  (add-to-list 'jinx-exclude-regexps
               `(org-mode
                 ;; for logic string
                 ,(rx word-start (repeat 1 10 (any "abcduvwxyz")) word-end)
                 ;; for unicode
                 "[a-zA-Z']*[^[:ascii:]äßöüÄÖÜ]+[a-zA-Z']*"
                 ))
  (add-to-list 'jinx-exclude-faces '(tex-mode font-lock-type-face))
  (with-eval-after-load 'org-ref-ref-links
    (add-to-list 'jinx-exclude-faces '(org-mode org-ref-ref-face))
    )

  (with-eval-after-load 'org
    (add-to-list 'jinx--predicates #'weiss-jinx--exclude-p)
    )
  )

;;; the following is just for debug
(defun weiss-test ()
  "DOCSTRING"
  (interactive)
  (let ((r (rx word-start (repeat 1 5 (any "abuvwxyz")) word-end))
        )
    (setq weiss/test-regex r)
    (setq jinx-exclude-regexps
          '((emacs-lisp-mode "Package-Requires:.*$")
            (t "[A-Z]+\\>"         ;; Uppercase words
               "-+\\>"             ;; Hyphens used as lines or bullet points
               "\\w*?[0-9]\\w*\\>" ;; Words with numbers, hex codes
               "[a-z]+://\\S-+"    ;; URI
               "<?[-+_.~a-zA-Z][-+_.~:a-zA-Z0-9]*@[-.a-zA-Z0-9]+>?" ;; Email
               "\\(?:Local Variables\\|End\\):\\s-*$" ;; Local variable indicator
               "jinx-\\(?:languages\\|local-words\\):\\s-+.*$")) ;; Local variables
          )
    (add-to-list 'jinx-exclude-regexps `(org-mode ,weiss/test-regex)) 
    (message "%s" (looking-at-p weiss/test-regex))    
    )
  )


(provide 'weiss_jinx_settings)


