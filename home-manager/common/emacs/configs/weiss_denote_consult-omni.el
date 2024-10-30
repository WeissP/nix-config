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
      (mapcar
       (lambda (item)
         (let ((dir (f-dirname item))
               (name (f-filename item)))
           (put-text-property 0 consult-omni-denote-fd-dir-invisible-length 'invisible t dir)
           (put-text-property 0 consult-omni-denote-fd-name-invisible-length 'invisible t name)       
           (concat dir "/" name)
           )
         )
       candidates)
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
                (file (denote--command-with-features #'denote nil nil t nil)))
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
    )
  )

(provide 'weiss_denote_consult-omni)
