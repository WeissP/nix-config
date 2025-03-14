;; (with-eval-after-load 'org
;;   (require 'org-ref)
;;   )

(with-eval-after-load 'org-ref
  (custom-set-faces
   '(org-ref-ref-face ((t (:inherit org-link))))
   )

  (defun weiss-org-ref-insert-labels (label)
    "DOCSTRING"
    (interactive
     (list
      (completing-read "Label: " (org-ref-get-labels))      
      ))
    (let ((prefix "  "))
      (cond
       ((string-prefix-p "fig" label)
        (setq prefix " Figure "))
       ((string-prefix-p "lemma" label)
        (setq prefix " Lemma "))
       ((string-prefix-p "alg" label)
        (setq prefix " Algorithm "))
       ((string-prefix-p "sec" label)
        (setq prefix " Section "))
       ((string-prefix-p "eq" label)
        (setq prefix " Equation "))
       ((string-prefix-p "lst" label)
        (setq prefix " Listing "))
       ((string-prefix-p "tbl" label)
        (setq prefix " Table "))
       )
      (insert (format "%s[[ref:%s]]" prefix label))
      )
    )
  ;; (setq bibtex-completion-bibliography '(("seminar-report.org" . "refs.bib")))

  )

(provide 'weiss_org-ref_settings)
