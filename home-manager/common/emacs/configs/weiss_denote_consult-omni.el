;;; -*- lexical-binding: t -*-

(with-eval-after-load 'consult-omni
  (with-eval-after-load 'weiss_denote_settings
    (require 'f)

    (setq
     consult-omni-denote-fd-args (list "fd" "--absolute-path --color=never -e org -e pdf")
     consult-omni-denote-fd-dir-invisible-length (length denote-directory)
     consult-omni-denote-fd-name-invisible-length 17
     )

    (defun consult-omni--denote-fd-transform (candidates &optional query)
      "Formats candidates of `consult-omni-denote-fd'."
      (->>
       candidates
       (-filter #'denote-file-has-identifier-p )
       (mapcar
        (lambda (item)
          (let ((dir-len (+ (length (f-dirname item)) 1))
                )
            (put-text-property 0 consult-omni-denote-fd-dir-invisible-length 'invisible t item)
            (put-text-property
             dir-len
             (+  dir-len consult-omni-denote-fd-name-invisible-length)
             'invisible t item)
            item
            )
          )
        )
       )
      )

    (defun consult-omni--denote-fd-preview (cand)
      "Preview function for `consult-omni-denote-fd'." 
      (funcall (consult--file-preview) 'preview cand))

    (defun consult-omni--denote-fd-callback (cand)
      "Callback for `consult-omni-denote-fd'."
      (consult--file-action cand))

    (cl-defun consult-omni--denote-fd-builder (input &rest args &key callback &allow-other-keys)
      "Makes builder command line args for “fd”."
      (pcase-let* ((`(,query . ,opts) (consult-omni--split-command input (seq-difference args (list :callback callback))))
                   (opts (car-safe opts))
                   (count (plist-get opts :count))
                   (case-sensitive (if (plist-member opts :case) (plist-get opts :case) nil))
                   (exclude (or (plist-get opts :ignore) (plist-get opts :exclude)))
                   (exclude (if exclude (format "%s" exclude)))
                   (dir denote-directory)
                   (count (or (and count (integerp (read count)) (string-to-number count))
                              consult-omni-default-count))
                   (default-directory denote-directory)
                   (`(_ ,paths _) (consult--directory-prompt "" dir))
                   (paths (if dir 
                              (mapcar (lambda (path) (file-truename (concat dir path))) paths)
                            paths))
                   (consult-fd-args (append consult-omni-denote-fd-args
                                            (and case-sensitive (list "--case-sensitive"))
                                            (and exclude (list (concat "--exclude " exclude))))))
        (funcall (consult--fd-make-builder paths) query)))

    (defun consult-omni--notes-new-create-denote (&optional string)
      "Makes new denote note"
      (if-let* ((_ (push string denote-title-history))
                (file (denote--command-with-features #'denote t nil t nil)))
          (consult-omni-propertize-by-plist string `(:title ,string :source "Notes Search" :url nil :search-url nil :query ,string :file ,(file-truename file)))))

    ;; Define the denote Source
    (consult-omni-define-source
     "denote-fd"
     :narrow-char ?n 
     :category 'file
     :type 'async
     :require-match nil
     :face 'consult-omni-engine-title-face
     :request #'consult-omni--denote-fd-builder
     :transform #'consult-omni--denote-fd-transform
     :on-preview #'consult-omni--denote-fd-preview
     :on-return #'identity
     :on-new #'consult-omni--notes-new-create-denote
     :on-callback #'consult-omni--denote-fd-callback
     :preview-key consult-omni-preview-key
     :search-hist 'consult-omni--search-history
     :select-hist 'consult-omni--selection-history
     :group #'consult-omni--group-function
     :sort nil
     :interactive consult-omni-intereactive-commands-type
     :enabled (lambda () (and 
                          (bound-and-true-p denote-directory)
                          (or (executable-find "fdfind")
                              (executable-find "fd"))))
     :annotate nil)
    
    (add-to-list 'consult-omni-multi-sources "denote-fd")

    (defun weiss-consult-omni-denote-insert-link (cand)
      "DOCSTRING" 
      (interactive)
      (let* ((insert-fun (consult--read
                          '("denote-insert-link" "denote-org-extras-link-to-heading")
                          :prompt "Insert link of note: "
                          ))
             )
        (pcase insert-fun
          ("denote-insert-link" (denote-link
                                 cand 'org 
                                 (denote--retrieve-title-or-filename cand 'org)
                                 ))
          ("denote-org-extras-link-to-heading"
           (weiss-denote-org-extras-link-to-heading
            cand 
            nil
            #'weiss-denote-link-format-heading-description
            ))
          (_ (error "unimplemented"))
          )
        ))

    (defun consult-omni--denote-heading-link-fetching-results (input &rest args)
      "DOCSTRING"
      (interactive)
      (->>
       (buffer-file-name (window-buffer (minibuffer-selected-window)))
       ((lambda (f) (ignore-errors (denote-org-extras--get-outline f))))       
       (orderless-filter input )
       (mapcar 
        (lambda (item)
          (propertize
           item
           :source "Denote heading link"
           :title item
           :url nil
           :query item
           :search-url nil
           )
          )
        )
       )      
      )
    
    (defun weiss-denote-org-extras-link-to-heading (file heading &optional heading-description)
      "DOCSTRING"
      (interactive)
      (let* ((heading-description (or heading-description #'denote-link-format-heading-description))
             (file (or file (buffer-file-name (window-buffer (minibuffer-selected-window)))))
             (file-text (denote--link-get-description file))
             (heading (or heading (denote-org-extras-outline-prompt file)))
             (line (string-to-number (car (split-string heading "\t"))))
             (heading-data (denote-org-extras--get-heading-and-id-from-line line file))
             (heading-text (car heading-data))
             (heading-id (cdr heading-data))
             (description (funcall heading-description file-text heading-text)))
        (insert (denote-org-extras-format-link-with-heading file heading-id description))
        )
      )

    (defun weiss-consult-omni-denote-heading-insert-link (cand)
      "DOCSTRING" 
      (interactive)
      (weiss-denote-org-extras-link-to-heading
       nil
       cand
       (lambda (file-text heading-text) heading-text))
      )

    (consult-omni-define-source
     "Denote fd link"
     :narrow-char ?l 
     :category 'file
     :type 'async
     :require-match t
     :face 'consult-omni-engine-title-face
     :request #'consult-omni--denote-fd-builder
     :transform #'consult-omni--denote-fd-transform
     :on-preview #'consult-omni--denote-fd-preview
     :on-return #'identity
     :on-new #'consult-omni--notes-new-create-denote
     :on-callback #'weiss-consult-omni-denote-insert-link
     :preview-key consult-omni-preview-key
     :search-hist 'consult-omni--search-history
     :select-hist 'consult-omni--selection-history
     :group #'consult-omni--group-function
     :sort nil
     :interactive consult-omni-intereactive-commands-type
     :enabled (lambda () (and 
                          (bound-and-true-p denote-directory)
                          (or (executable-find "fdfind")
                              (executable-find "fd"))))
     :annotate nil)

    (consult-omni-define-source 
     "Denote heading link"
     :narrow-char ?h 
     :category 'org-heading
     :type 'sync
     :require-match t 
     :sort nil
     :face 'consult-omni-engine-title-face
     :request #'consult-omni--denote-heading-link-fetching-results
     :on-return #'identity
     :on-callback #'weiss-consult-omni-denote-heading-insert-link
     :preview-key nil
     :search-hist 'consult-omni--search-history
     :select-hist 'consult-omni--selection-history
     :group #'consult-omni--group-function
     :sort nil
     :interactive consult-omni-intereactive-commands-type
     :annotate nil)
    )

  (defun weiss-denote-consult-omni-link ()
    "DOCSTRING"
    (interactive)
    (let ((consult-omni-multi-sources '("Denote fd link" "Denote heading link"))
          )
      (consult-omni-multi)
      ))
  )

(provide 'weiss_denote_consult-omni)
