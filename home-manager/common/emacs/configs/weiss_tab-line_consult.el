(with-eval-after-load 'consult
  (setq weiss-consult-source-tab-group
        (list
         :name     "tab-group"
         :category 'tab-group
         :narrow   ?t
         :action #'weiss-load-tab-group
         :new #'weiss-tab-bind-group 
         :items #'weiss-tab-all-group-names                
         ))
  (add-to-list 'consult-buffer-sources #'weiss-consult-source-tab-group t)
  )

(provide 'weiss_tab-line_consult)
