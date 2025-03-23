(with-eval-after-load 'org
  (require 'org-ref)
  )

(setq
 org-ref-insert-cite-function
 (lambda ()
   (org-cite-insert nil)))

(defun weiss-org-ref-insert-labels (label)
  "DOCSTRING" 
  (interactive
   (list 
    (completing-read "Label: " (org-ref-get-labels))      
    ))
  (let ((prefix "  "))
    (cond
     ((string-prefix-p "thm" label)
      (setq prefix " Theorem "))
     ((string-prefix-p "qry" label)
      (setq prefix " Query "))
     ((string-prefix-p "inv" label)
      (setq prefix " Invariant "))
     ((string-prefix-p "def" label)
      (setq prefix " Definition "))
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
     ((string-prefix-p "fig" label)
      (setq prefix " Figure "))
     )
    (insert (format "%s[[ref:%s]]" prefix label))
    )
  )

(with-eval-after-load 'org-ref-ref-links
  (custom-set-faces
   '(org-ref-ref-face ((t (:inherit org-link))))
   )
  )

(provide 'weiss_org-ref_settings)
