(setq consult-omni-multi-sources '("Buffer"))
(setq 
 consult-async-min-input 0
 consult-omni-sources-modules-to-load '(consult-omni-buffer)
 consult-omni-show-preview t    
 consult-omni-default-interactive-command #'consult-omni-multi
 consult-omni-dynamic-input-debounce 0.3
 consult-omni-dynamic-input-throttle consult-omni-dynamic-input-debounce
 ;; consult-async-split-style 'comma 
 consult-async-split-style 'perl
 )

(with-eval-after-load 'consult-omni  
  (require 'consult-omni-sources)
  (consult-omni-sources-load-modules)

  (defun consult-omni--choose-new (cand &rest args)
    "Create new item based on chosen source"
    (interactive)
    (let* ((sources
            (cl-remove-duplicates
             (delq nil (mapcar (lambda (item)
                                 (when-let ((new (consult-omni--get-source-prop item :on-new))
                                            (name (consult-omni--get-source-prop item :name)))
                                   (when (not (eq new #'consult-omni--default-new)) 
                                     (cons name new)))) 
                               consult-omni-multi-sources))))
           (action (consult--read sources
                                  :prompt "Create a new item on source: "
                                  :lookup #'consult--lookup-cdr
                                  )))
      (if (functionp action) 
          (funcall action cand)
        (error "Do not know how to make a new item for that source!"))))
  (setq consult-omni-default-new-function #'consult-omni--choose-new)
  )

(provide 'weiss_consult-omni_settings)
