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
  (let ((prefix (if (looking-back (rx (or line-start space)) 1)
                    "" "  "))
        (name (cond
               ((string-prefix-p "thm" label)
                "Theorem " )
               ((string-prefix-p "qry" label)
                "Query " )
               ((string-prefix-p "inv" label)
                "Invariant " )
               ((string-prefix-p "def" label)
                "Definition " )
               ((string-prefix-p "lemma" label)
                "Lemma " )
               ((string-prefix-p "alg" label)
                "Algorithm " )
               ((string-prefix-p "sec" label)
                "Section " )
               ((string-prefix-p "eq" label)
                "Equation " )
               ((string-prefix-p "lst" label)
                "Listing " )
               ((string-prefix-p "tbl" label)
                "Table " )
               ((string-prefix-p "fig" label)
                "Figure " )
               ((string-prefix-p "enum" label)
                " " )
               )))
    (insert (format "%s%s[[ref:%s]]" prefix name label))
    )
  )

(defun weiss-test ()
  "DOCSTRING"
  (interactive)
  (message "%s" (looking-back (rx (or line-start space)) 1)))

(with-eval-after-load 'org-ref-ref-links
  (custom-set-faces
   '(org-ref-ref-face ((t (:inherit org-link))))
   )
  )

(provide 'weiss_org-ref_settings)
