(defun weiss-citar-denote--update-last-created-note-cite-key (citekey &rest args)
  "DOCSTRING"
  (interactive)
  (setq weiss-citar-denote--last-created-note-cite-key citekey)
  )

(defun weiss-citar-denote-org-note-template ()
  "DOCSTRING"
  (interactive)
  (concat
   (format "[cite:@%s]" weiss-citar-denote--last-created-note-cite-key)      
   "\n\n"
   "* notes"
   "\n"
   ":PROPERTIES:"
   "\n"
   ":NOTER_DOCUMENT: "
   (->
    weiss-citar-denote--last-created-note-cite-key
    (citar--select-resource  :files t)
    (cdr)
    (f-relative)      
    )
   "\n" 
   ":END:"
   "\n"
   )
  )

(with-eval-after-load 'citar-denote
  (setq
   citar-open-always-create-notes nil
   citar-denote-file-type 'org
   citar-denote-subdir nil
   citar-denote-signature nil
   citar-denote-template nil
   citar-denote-keyword "bib"
   citar-denote-use-bib-keywords nil
   citar-denote-title-format "title"
   citar-denote-title-format-authors 1
   citar-denote-title-format-andstr "and"
   citar-denote-signature t
   ;; citar-notes-paths (list denote-directory)
   )

  (defvar weiss-citar-denote--last-created-note-cite-key)
  (advice-add 'citar-denote--create-note
              :before #'weiss-citar-denote--update-last-created-note-cite-key)


  ;; (add-to-list 'denote-templates '(citar-org-note . weiss-citar-denote-org-note-template))
  (setq citar-denote-template 'citar-org-note)

  ;; (defun weiss-citar-denote--create-note (citekey &optional _entry)
  ;;   "let notes created at academic dir"
  ;;   (denote
  ;;    (read-string "Title: " (citar-denote--generate-title citekey))
  ;;    (citar-denote--keywords-prompt citekey)
  ;;    citar-denote-file-type
  ;;    (concat (weiss-denote-consult--get-dir-by-name "academic") "notes")
  ;;    nil
  ;;    (when citar-denote-template (denote-template-prompt))
  ;;    (when citar-denote-signature (denote-signature-prompt
  ;;                                  citekey
  ;;                                  "Signature (empty to use citation key)")))
  ;;   (citar-denote--add-reference citekey citar-denote-file-type))
  ;; (advice-add 'citar-denote--create-note :override #'weiss-citar-denote--create-note)

  ;; (defun weiss-citar-denote--pdf-note-keywords (&optional additional-keywords)
  ;;   "let notes created at academic dir"
  ;;   (interactive)
  ;;   (let* ((name (buffer-name))
  ;;          (citekey (s-chop-suffix ".pdf" name))
  ;;          )
  ;;     ;; additional-keywords
  ;;     (if (weiss-citekey-p citekey)
  ;;         (append
  ;;          (list citekey)
  ;;          additional-keywords
  ;;          (when citar-denote-use-bib-keywords
  ;;   	     (ignore-errors (citar-denote--extract-keywords citekey))
  ;;   	     )
  ;;          )
  ;;       additional-keywords
  ;;       )
  ;;     )
  ;;   )
  
  ;; (advice-remove 'weiss-denote-pdf-note #'weiss-citar-denote--pdf-note-keywords)
  ;; (advice-add 'weiss-denote-pdf-note :filter-args #'weiss-citar-denote--pdf-note-keywords)
  (define-globalized-minor-mode weiss-global-citar-denote-mode citar-denote-mode
    (lambda () (citar-denote-mode 1)))
  (weiss-global-citar-denote-mode 1)
  )



(provide 'weiss_citar-denote_settings)
