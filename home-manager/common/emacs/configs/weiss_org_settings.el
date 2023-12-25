(defvar weiss/org-file-path "~/Documents/OrgFiles/")
(defvar weiss/org-img-path "~/Documents/Org-roam/Bilder/")
(defun weiss--get-org-file-path (path)
  "get org-file path according to weiss/org-file-path"
  (interactive)
  (concat weiss/org-file-path path))


(with-eval-after-load 'org
  (setq
   org-imenu-depth 10
   org-startup-with-inline-images nil
   org-src-preserve-indentation t
   org-directory weiss/org-file-path
   org-extend-today-until 4
   org-cycle-max-level 15
   org-catch-invisible-edits 'smart
   org-latex-prefer-user-labels t
   org-goto-interface 'outline-path-completion
   org-M-RET-may-split-line t
   org-id-link-to-org-use-id 'create-if-interactive
   org-outline-path-complete-in-steps nil
   )

  (defun weiss-org--latex-env-p ()
    "DOCSTRING"
    
    )

  (defun weiss-org-id-complete-link (&optional arg)
    "From Stackoverflow. Create an id: link using completion"
    (concat "id:" (org-id-get-with-outline-path-completion)))
  (org-link-set-parameters "id" :complete 'weiss-org-id-complete-link)
  (org-link-set-parameters "id" :insert-description "above")
  )



(provide 'weiss_org_settings)
