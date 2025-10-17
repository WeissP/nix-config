(defun weiss-org-publish-notes (&optional force)
  "DOCSTRING"
  (interactive "P")
  (let ((org-export-with-broken-links 'mark)
        (name "update_meili_index")
        (script-dir (getenv "SCRIPTS_DIR"))
        (org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")
        )
    (org-publish-all force)
    (start-process-shell-command
     name
     (get-buffer-create name)
     (format "nu %s/gen_denote_index.nu" script-dir)
     )
    (message "successfully published all notes!")
    )
  )

(defun weiss-org-publish-generate-alist (dir &optional rec)
  "DOCSTRING"
  (let* ((rel-path (file-relative-name dir weiss-org-html-export-from-dir))
         (base (file-name-as-directory dir))
         (name (weiss-get-parent-path base))
         (notes (concat base "notes") )
         (images (concat (file-name-as-directory notes) "images") )
         (base-out (concat weiss-org-html-export-dir rel-path))
         (notes-out (concat (file-name-as-directory base-out) "notes"))
         (images-out (concat (file-name-as-directory notes-out) "images"))
         )
    `(
      (,name
       :base-directory ,notes
       :base-extension "org"
       :publishing-directory ,notes-out
       :recursive ,rec
       :org-export-with-tags t
       :publishing-function org-html-publish-to-html
       :auto-preamble t
       :complete-function #'weiss-org-publish-on-complete 
       )

      (,(concat name "-images")
       :base-directory ,images
       :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
       :publishing-directory ,images-out
       :recursive ,rec
       :publishing-function org-publish-attachment
       )
      )
    ))

(with-eval-after-load 'org
  (require 'ox-publish)
  (setq weiss-org-html-export-from-dir (file-name-as-directory denote-directory)
        weiss-org-html-export-dir (file-name-as-directory "~/Documents/notes-export/notes/")
        org-html-validation-link nil
        org-html-head-include-default-style nil
        
        )

  
  (setq org-publish-project-alist
        (append 
         (weiss-org-publish-generate-alist "~/Documents/notes/ddm" :recursive)
         (-flatten-n 1 (--map (weiss-org-publish-generate-alist it :recursive) (f-directories "~/Documents/notes/papers/")))
         `(("misc" 
            :base-directory "~/Documents/notes/"
            :base-extension "org"
            :publishing-directory ,weiss-org-html-export-dir
            :recursive nil
            :publishing-function org-html-publish-to-html
            :auto-preamble t
            :org-export-with-tags t
            )
           ("misc-images" 
            :base-directory "~/Documents/notes/images" 
            :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
            :publishing-directory ,(f-join weiss-org-html-export-dir "images")
            :recursive nil
            :publishing-function org-publish-attachment
            )
           )
         )
        )

  (when (weiss-emacs-server-p)
    (setq weiss-org-publish-notes-on-idle (run-with-idle-timer (* 60 60) t #'weiss-org-publish-notes))
    )
  )

(provide 'weiss_org_publish)
