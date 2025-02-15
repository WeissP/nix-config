(with-eval-after-load 'consult-omni-sources
  (defun consult-omni--emacs-config-fetch-results (input &rest args)
    (orderless-filter input (directory-files weiss/configs-dir t "weiss\_.*el"))
    )

  (setq
   consult-omni--emacs-config-invisible-length (+ (length weiss/configs-dir) 6)
   )

  (defun consult-omni--emacs-config-transform (candidates &optional query)
    (mapcar
     (lambda (item)
       (put-text-property 0 consult-omni--emacs-config-invisible-length 'invisible t item)
       (propertize
        item
        :source "Emacs Config"
        :title item
        :url nil
        :query item
        :search-url nil
        )         
       )
     candidates)
    )

  (defun weiss-find-emacs-config (cand)
    "DOCSTRING"
    (consult--file-action cand)
    )
  
  (consult-omni-define-source
   "Emacs Config" 
   :min-input 2
   :category 'emacs-config
   :narrow-char ?e
   :on-callback #'weiss-find-emacs-config
   :face     'consult-file
   :on-new #'weiss-new-emacs-config-file 
   :require-match nil
   :state    #'consult--file-state
   :type 'sync
   :on-return #'identity
   :group #'consult-omni--group-function
   :sort nil 
   :interactive consult-omni-intereactive-commands-type
   :annotate nil
   :request #'consult-omni--emacs-config-fetch-results
   :transform #'consult-omni--emacs-config-transform
   )
  
  (add-to-list 'consult-omni-multi-sources "Emacs Config")
  )

(provide 'weiss_consult-omni_emacs-config)
