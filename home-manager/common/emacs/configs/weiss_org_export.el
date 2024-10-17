(setq org-export-backends '(html latex md))

(with-eval-after-load 'org
  (setq
   org-export-allow-bind-keywords t
   org-export-with-sub-superscripts nil
   org-export-preserve-breaks nil
   org-export-with-creator nil
   org-export-with-author t
   org-export-with-section-numbers 5
   org-export-with-smart-quotes t
   org-export-with-toc nil
   org-export-with-latex t
   org-export-preserve-breaks t
   org-export-with-date nil
   org-latex-caption-above nil
   )
  
  (setq org-cite-export-processors
        '( (latex biblatex)                                   
           (t basic))
        )

  (setq org-html-mathjax-options
        '((path "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js")
          (scale 1.0)
          (align "left")
          (font "mathjax-modern")
          (overflow "overflow")
          (tags "ams")
          (indent "0em")
          (multlinewidth "85%")
          (tagindent ".8em")
          (tagside "right"))
        )

  ;; (add-to-list 'org-export-backends 'md)
  ;; (setq org-export-backends '(html latex md))

  (defun weiss-org-export-latex-pdf ()
    "DOCSTRING"
    (interactive)
    (deactivate-mark)
    (ignore-errors 
      (call-interactively 'save-buffer))
    (let ((warning-minimum-level :error))
      (if org-beamer-mode
          (call-interactively 'org-beamer-export-to-pdf)
        (call-interactively 'org-latex-export-to-pdf)    
        )
      )    
    )
  )

(provide 'weiss_org_export)
