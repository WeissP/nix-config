(defvar weiss-consult-omni-current-buffer nil)
(defun consult--buffer-sort-omni-current (buffers)
  "put current at the beginning."
  (let ((current weiss-consult-omni-current-buffer))
    (if (memq current buffers)
        (cons current (delq current buffers))
      buffers)))

;; `consult-omni-multi' is already overriden by weiss-consult-omni-multi
;; (defun weiss-with-consult-omni-current-buffer (f &rest args)
;;   "DOCSTRING"
;;   (interactive)
;;   (let ((weiss-consult-omni-current-buffer (current-buffer)))
;;     (apply f args)
;;     )) 
;; (advice-add 'consult-omni-multi :around #'weiss-with-consult-omni-current-buffer)


(with-eval-after-load 'consult-omni
  (defun weiss-consult-omni--buffer-fetch-results (input &rest args)
    "DOCSTRING"
    (interactive)
    (orderless-filter
     input
     (consult--buffer-query :sort 'omni-current
                            :filter t 
                            :as #'consult--buffer-pair)
     )
    )

  (defun weiss-consult-omni--buffer-transform (candidates &optional query)
    (mapcar
     (lambda (item)
       (let ((name (or (car-safe item) item)))
         (propertize
          name
          :source "Buffer"
          :title name
          :url nil 
          :query query
          :search-url nil
          )
         )         
       )
     candidates)
    )

  (defun weiss-consult-omni--hidden-buffer-fetch-results (input &rest args)
    "DOCSTRING"
    (interactive)
    (orderless-filter
     input
     (consult--buffer-query :sort nil
                            :filter 'invert 
                            :as #'consult--buffer-pair)
     )
    )

  (defun weiss-consult-omni--hidden-buffer-transform (candidates &optional query)
    (mapcar
     (lambda (item)
       (let ((name (or (car-safe item) item)))
         (propertize
          name
          :source "Hidden Buffer"
          :title name
          :url nil 
          :query query
          :search-url nil
          )
         )         
       )
     candidates)
    )
  
  (consult-omni-define-source
   "Buffer" 
   :min-input 0
   :on-preview #'consult-omni--consult-buffer-preview
   :on-return #'identity
   :on-callback #'consult--buffer-action
   :category 'buffer
   :narrow-char ?b
   :face     'consult-buffer
   :history  'buffer-name-history
   :on-new #'consult--buffer-action
   :search-hist 'consult-omni--search-history
   :select-hist 'consult-omni--selection-history
   :group #'consult-omni--group-function
   :require-match nil 
   :state    #'consult--buffer-state
   :type 'sync
   :on-return #'identity
   :sort nil 
   :interactive 'consult-omni-intereactive-commands-type
   :annotate nil
   :request #'weiss-consult-omni--buffer-fetch-results
   :transform #'weiss-consult-omni--buffer-transform
   )

  (consult-omni-define-source
   "Hidden Buffer" 
   :min-input 1
   :on-preview #'consult-omni--consult-buffer-preview
   :on-return #'identity
   :on-callback #'consult--buffer-action
   :category 'buffer
   :narrow-char ?h
   :face     'consult-buffer
   :history  'buffer-name-history
   :on-new #'consult--buffer-action
   :search-hist 'consult-omni--search-history
   :select-hist 'consult-omni--selection-history
   :group #'consult-omni--group-function
   :require-match nil 
   :state    #'consult--buffer-state
   :type 'sync
   :on-return #'identity
   :sort nil 
   :interactive 'consult-omni-intereactive-commands-type
   :annotate nil
   :request #'weiss-consult-omni--hidden-buffer-fetch-results
   :transform #'weiss-consult-omni--hidden-buffer-transform
   :enabled 
   )

  (add-to-list 'consult-omni-multi-sources "Buffer")
  (add-to-list 'consult-omni-multi-sources "Hidden Buffer")
  )

(provide 'weiss_consult-omni_buffer)
