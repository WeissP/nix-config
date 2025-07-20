(with-eval-after-load 'org
  (require 'citeproc)
  (setq
   org-cite-global-bibliography weiss/bibs
   org-cite-export-processors
   '((latex biblatex)                                    
     (t basic))
   )
  )

(provide 'weiss_org-cite_settings)
