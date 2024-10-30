(setq consult-omni-multi-sources '("Buffer"))
(setq 
 consult-omni-sources-modules-to-load '(consult-omni-buffer)
 consult-omni-show-preview t    
 consult-omni-default-interactive-command #'consult-omni-multi
 consult-omni-dynamic-input-debounce 0.3
 consult-omni-dynamic-input-throttle consult-omni-dynamic-input-debounce
 )

(with-eval-after-load 'consult-omni
  (require 'consult-omni-sources)
  (consult-omni-sources-load-modules)
 
  (defun consult-omni--choose-new (cand &rest args)
    "Create new item based on chosen source"
    (interactive)
    (let* ((source (completing-read
                    "Create new item on source: "
                    consult-omni-multi-sources 
                    ))
           (action (consult-omni--get-source-prop source :on-new)))
      (funcall action cand)
      ))
  (setq consult-omni-default-new-function #'consult-omni--choose-new)
  )

(defun weiss-test ()
  "DOCSTRING"
  (interactive)
  (consult-omni-multi))

(provide 'weiss_consult-omni_settings)
