(with-eval-after-load 'org
  (require 'ox-publish)
  (setq weiss-org-html-export-from-dir (file-name-as-directory denote-directory))
  (setq weiss-org-html-export-dir
        (file-name-as-directory "~/Documents/notes-export/html/"))

  (defun weiss-org-publish-generate-alist (dir)
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
         :recursive t
         :publishing-function org-html-publish-to-html
         :auto-preamble t
         )

        (,(concat name "-images")
         :base-directory ,images
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory ,images-out
         :recursive t
         :publishing-function org-publish-attachment
         )
        )
      ))

  (setq org-publish-project-alist
        (append
         (weiss-org-publish-generate-alist "~/Documents/notes/lectures/Probability_and_Algorithms/")
         (weiss-org-publish-generate-alist "~/Documents/notes/lectures/machine_learning2/")
         (weiss-org-publish-generate-alist "~/Documents/notes/lectures/concurrency_theory/")
         `(("meta"
            :base-directory "~/Documents/notes/"
            :base-extension "org"
            :publishing-directory ,weiss-org-html-export-dir
            :recursive nil
            :publishing-function org-html-publish-to-html
            :auto-preamble t
            ))
         )
        )
  )

(provide 'weiss_org_publish)
