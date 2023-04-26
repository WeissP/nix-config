(with-eval-after-load 'org
  (require 'maxima)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((maxima . t)))
  )

(with-eval-after-load 'maxima
  (require 'company-maxima)
  (add-to-list 'company-backends '(company-maxima-symbols company-maxima-libraries))
  )
;; parent: 
(provide 'weiss_maxima_settings)
