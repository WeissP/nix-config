(with-eval-after-load 'citar
  (setq 
   citar-bibliography (list weiss/bibs)
   citar-library-paths (list weiss/academic-documents)
   )

  (setq
   org-cite-insert-processor 'citar
   org-cite-follow-processor 'citar
   org-cite-activate-processor 'citar
   )



  (defun weiss-citekey-p (citekey)
    "DOCSTRING"
    (interactive)
    (citar-get-entry citekey))
  )

(provide 'weiss_citar_settings)

