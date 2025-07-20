(defun weiss-citekey-p (citekey)
  "DOCSTRING"
  (interactive)
  (citar-get-entry citekey))

(with-eval-after-load 'citar
  (setq 
   citar-bibliography weiss/bibs
   citar-library-paths (list weiss/academic-documents)
   )

  (setq
   org-cite-insert-processor 'citar
   org-cite-follow-processor 'citar
   org-cite-activate-processor 'citar
   )

  (with-eval-after-load 'embark
    (require 'citar-embark)
    )
  )

(provide 'weiss_citar_settings)

