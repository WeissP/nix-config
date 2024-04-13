(with-eval-after-load 'org
  (setq
   org-cite-global-bibliography '("/home/weiss/Documents/Vorlesungen/bachelorarbeit/bsc-thesis-bozhou/main.bib")
   org-cite-export-processors
   '((md . (csl "chicago-fullnote-bibliography.csl"))   ; Footnote reliant
     (latex biblatex)                                   ; For humanities
     (odt . (csl "chicago-fullnote-bibliography.csl"))  ; Footnote reliant
     (t . (csl "modern-language-association.csl")))
   ))

(provide 'weiss_org-cite_settings)
