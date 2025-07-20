(defvar weiss/org-file-path "~/Documents/OrgFiles/")
(defvar weiss/org-img-path (file-name-as-directory (concat weiss/notes-dir "images")))
(defun weiss--get-org-file-path (path)
  "get org-file path according to weiss/org-file-path"
  (interactive)
  (concat weiss/org-file-path path))

(defun weiss-org-id-complete-link (&optional arg)
  "From Stackoverflow. Create an id: link using completion"
  (concat "id:" (org-id-get-with-outline-path-completion)))

(defun weiss-org-preview-or-latex-quick-insert ()
  "DOCSTRING"
  (interactive)
  (if (and
       (not current-prefix-arg)
       (weiss-region-p)
       (or
        (eq 'latex-fragment (org-element-type (org-element-context (org-element-at-point))))
        (eq 'latex-environment (org-element-type (org-element-context (org-element-at-point))))
        ))
      (call-interactively 'quick-insert-insert-latex)
    (call-interactively 'weiss-org-preview-latex-and-image)
    )
  )

(defun weiss-org-insert-link ()
  "DOCSTRING"
  (interactive)
  (if (null org-stored-links)
      (call-interactively 'org-insert-link)
    (call-interactively 'org-insert-last-stored-link)
    )
  )

(with-eval-after-load 'org
  (setq
   org-imenu-depth 10
   org-startup-with-inline-images t
   org-startup-with-latex-preview nil
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
   org-preview-latex-default-process 'dvisvgm
   ;; org-preview-latex-default-process 'dvipng
   org-return-follows-link t
   )

  (org-link-set-parameters "id" :complete 'weiss-org-id-complete-link)
  ;; (org-link-set-parameters "id" :insert-description "above")

  ;; export snippet translations
  (add-to-list 'org-export-snippet-translation-alist
               '("b" . "beamer"))
  )



(provide 'weiss_org_settings)
