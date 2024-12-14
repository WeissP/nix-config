;;; -*- lexical-binding: t -*-
 
(with-eval-after-load 'consult-omni-faklsdfjas
  (consult--command-split "")

  (consult--buffer-query :sort 'visibility
                         :as #'consult--buffer-pair)

  (cl-defun consult-omni--buffer-fetch-results (input &rest args)
    (pcase-let* ((`(,query . ,opts) (consult-omni--split-command input args))
                 (opts (car-safe opts))
                 )
      (->>
       (consult--buffer-query :sort 'visibility
                              :as #'consult--buffer-pair)
       (-map #'car)       
       (orderless-filter query)
       
       )
      ;; (delq nil (mapcar (lambda (item)
      ;;                     (if (consp item) (setq item (or (car-safe item) item)))
      ;;                     (when (orderless-filter query item)
      ;;                       (propertize item 
      ;;                                   :source "Buffer" 
      ;;                                   :title item
      ;;                                   :url nil
      ;;                                   :query query
      ;;                                   :search-url nil
      ;;                                   )))
      ;;                   results))
      )
    )

  (let ((query "co")
        )
    (->>
     (consult--buffer-query :sort 'visibility
                            :as #'consult--buffer-pair)
     (-map #'car)       
     (orderless-filter query)     
     ) 
    )
  
  (orderless-filter "query" "asdfsfd")

  (consult-omni--buffer-fetch-results "co")
  
  (consult-omni-define-source
   "Bufferf"
   :narrow-char ?b
   :category 'buffer
   :require-match t
   :request #'consult-omni--buffer-fetch-results
   :face     'consult-buffer
   :state    #'consult--buffer-state
   :type 'sync
   :on-preview #'consult-omni--consult-buffer-preview
   :on-return #'identity
   :on-callback #'consult--buffer-action
   :search-hist 'consult-omni--search-history
   :select-hist 'consult-omni--selection-history
   :interactive consult-omni-intereactive-commands-type
   :preview-key consult-omni-preview-key
   :on-new #'consult--buffer-action
   :group #'consult-omni--group-function
   :enabled (lambda () (bound-and-true-p consult--source-buffer))   
   :annotate nil)

  )

;; Define a Demo Source
;; (consult-omni-define-source
;;  "Demo"
;;  :type 'sync
;;  :request (lambda () '("___aaa" "___bbb" "___ccc""___ddd")))

(provide 'weiss_consult-omni_buffer)
