(with-eval-after-load 'consult-omni-sources
  (with-eval-after-load 'weiss_consult-omni_settings
    (defun consult-omni--tab-line-fetch-results (input &rest args)
      (orderless-filter input (weiss-tab-all-group-names))
      )

    (defun consult-omni--tab-line-transform (candidates &optional query)
      (mapcar
       (lambda (item)
         (propertize
          item
          :source "Tab Group"
          :title item
          :url nil
          :query item
          :search-url nil
          )
         )
       candidates)
      )
    
    (consult-omni-define-source
     "Tab Group" 
     :min-input 5 
     :category 'tab 
     :narrow-char ?t
     :type 'sync
     :require-match nil
     :face 'consult-omni-engine-title-face
     :request #'consult-omni--tab-line-fetch-results
     :transform #'consult-omni--tab-line-transform
     :on-return #'identity
     :on-callback #'weiss-load-tab-group
     :on-new #'weiss-tab-bind-group
     :preview-key nil
     :group #'consult-omni--group-function
     :sort nil 
     :interactive consult-omni-intereactive-commands-type
     :annotate nil
     )
    (add-to-list 'consult-omni-multi-sources "Tab Group")    
    )
  )

(provide 'weiss_tab-line_consult-omni)
