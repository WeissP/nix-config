(with-eval-after-load 'jinx
  (dolist (hook '(text-mode-hook conf-mode-hook))
    (add-hook hook #'jinx-mode))
  (setq jinx-languages "en de")

  ;; ignore all unicodes
  (add-to-list 'jinx-exclude-regexps '(org-mode "[a-zA-Z]*[^[:ascii:]äßöüÄÖÜ]+[a-zA-Z]*"))
  )

;;; the following is just for debug
;; (let ((r "[a-zA-Z]*[[:nonascii:]]+[a-zA-Z]*")
;;       )
;;   (setq weiss/test-regex r)
;;   (setq jinx-exclude-regexps
;;         '((emacs-lisp-mode "Package-Requires:.*$")
;;           (t "[A-Z]+\\>"         ;; Uppercase words
;;              "-+\\>"             ;; Hyphens used as lines or bullet points
;;              "\\w*?[0-9]\\w*\\>" ;; Words with numbers, hex codes
;;              "[a-z]+://\\S-+"    ;; URI
;;              "<?[-+_.~a-zA-Z][-+_.~:a-zA-Z0-9]*@[-.a-zA-Z0-9]+>?" ;; Email
;;              "\\(?:Local Variables\\|End\\):\\s-*$" ;; Local variable indicator
;;              "jinx-\\(?:languages\\|local-words\\):\\s-+.*$")) ;; Local variables
;;         )
;;   (add-to-list 'jinx-exclude-regexps `(org-mode ,weiss/test-regex)) 
;;   (defun weiss-test ()
;;     "DOCSTRING"
;;     (interactive)
;;     (message "%s" (looking-at-p weiss/test-regex)))
;;   )

(provide 'weiss_jinx_settings)


