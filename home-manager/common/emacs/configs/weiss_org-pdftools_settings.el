(with-eval-after-load 'org
  (with-eval-after-load 'pdf-tools
    (require 'org-pdftools)
    )
  )

(with-eval-after-load 'org-pdftools
  (add-hook 'org-mode-hook #'org-pdftools-setup-link)
  (defalias 'find-if 'cl-find-if)
  (defalias 'getf 'cl-getf)
  )

(provide 'weiss_org-pdftools_settings)
