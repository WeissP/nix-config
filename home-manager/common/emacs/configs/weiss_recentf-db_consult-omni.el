(with-eval-after-load 'consult-omni-sources
  (setq
   consult-omni-recentf-db-args (list recentf-executable "search")
   )

  (defun consult-omni--recentf-db-preview (cand)
    "Preview function for `consult-omni-recentf-db'." 
    (funcall (consult--file-preview) 'preview cand))

  (defun consult-omni--recentf-db-callback (cand)
    "Callback for `consult-omni-recentf-db'."
    (consult--file-action cand))

  (cl-defun consult-omni--recentf-db-builder (input &rest args &key callback &allow-other-keys)
    "Makes builder command line args for “fd”."
    (list recentf-executable "search" input))

  (defun consult-omni--notes-new-create-denote (&optional string)
    "Makes new denote note"
    (if-let* ((_ (push string denote-title-history))
              (file (denote--command-with-features #'denote nil nil t nil)))
        (consult-omni-propertize-by-plist string `(:title ,string :source "Notes Search" :url nil :search-url nil :query ,string :file ,(file-truename file)))))
  
  (defun consult-omni--recentf-db-filter (candidates &optional query)
    (seq-filter #'s-present? candidates)
    )
  
  (consult-omni-define-source
   "recentf-db"
   :narrow-char ?r
   :category 'file
   :type 'async
   :require-match t 
   :face 'consult-omni-engine-title-face
   :request #'consult-omni--recentf-db-builder
   :filter #'consult-omni--recentf-db-filter
   :on-preview #'consult-omni--recentf-db-preview
   :on-return #'identity
   :on-callback #'consult-omni--recentf-db-callback
   :preview-key consult-omni-preview-key
   :search-hist 'consult-omni--search-history
   :select-hist 'consult-omni--selection-history
   :group #'consult-omni--group-function
   :sort nil
   :interactive consult-omni-intereactive-commands-type
   :enabled (lambda () (bound-and-true-p recentf-executable))
   :annotate nil)

  (add-to-list 'consult-omni-multi-sources "recentf-db")
  )



(provide 'weiss_recentf-db_consult-omni)
