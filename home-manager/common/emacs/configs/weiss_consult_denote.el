;; -*- lexical-binding: t -*-

(with-eval-after-load 'weiss_consult_settings
  (with-eval-after-load 'denote
    (defvar weiss-denote--files-matching-regexp nil)
    (defun weiss-denote--list-notes (dir)
      "DOCSTRING"    
      (-map (lambda (s) (s-chop-left (length denote-directory) s))
            (-filter
             #'denote-file-has-identifier-p
             (directory-files-recursively
              dir
              directory-files-no-dot-files-regexp
              :include-directories
              (lambda (f)
                (cond
                 ((string-match-p "\\`\\." f) nil)
                 ((string-match-p "/\\." f) nil)
                 ((denote--exclude-directory-regexp-p f) nil)
                 ((file-readable-p f))
                 (files-matching-regexp
                  (string-match-p weiss-denote--files-matching-regexp f))
                 (t)))
              :follow-symlinks)))
      )

    (defun weiss-denote-consult--prompt-new-note-info (cand)
      "DOCSTRING"
      (if-let* ((cur-dir (expand-file-name default-directory))
                (config (--first (s-starts-with? (expand-file-name (plist-get it :dir)) cur-dir) weiss-denote-consult-source-config)))
          (denote cand (plist-get config :keywords) nil (concat (plist-get config :dir) "/notes") nil nil)        
        ;; from consult-notes
        (let* ((f (expand-file-name cand denote-directory))
               (f-dir (file-name-directory f))
               (f-name-base (file-name-base f))
               (file-type 'org)
               keywords date subdirectory template)
          (dolist (prompt denote-prompts)
            (pcase prompt
              ('keywords (setq keywords (denote-keywords-prompt)))
              ('file-type (setq file-type (denote-file-type-prompt)))
              ('subdirectory (setq subdirectory (denote-subdirectory-prompt)))
              ('date (setq date (denote-date-prompt)))
              ('template (setq template (denote-template-prompt)))))
          (denote (string-trim f-name-base) keywords file-type subdirectory date template))
        ))

    (defun weiss-denote-org-extract-subtree ()
      "based on denote manual
Create new Denote note using current Org subtree.
Make the new note use the Org file type, regardless of the value
of `denote-file-type'.

Use the subtree title as the note's title.  If available, use the
tags of the heading are used as note keywords.

Delete the original subtree."
      (interactive)
      (if-let ((heading (org-get-heading :no-tags :no-todo :no-priority :no-comment)))
          (let ((element (org-element-at-point))
                (tags (org-get-tags))
                )
            (kill-new "")
            (call-interactively 'org-copy-subtree)
            (delete-other-windows)
            (weiss-split-window-dwim)
            (other-window 1)
            (weiss-denote-consult--prompt-new-note-info heading)          
            (org-paste-subtree)
            (goto-char (point-min))
            (org-delete-property-globally "NOTER_PAGE")
            (org-delete-property-globally "ID")
            (search-forward "* " nil t)                
            (delete-line)
            (goto-char (point-min))
            (while (search-forward "** " nil t)
              (replace-match "* ")
              )
            (goto-char (point-min))
            (save-buffer)
            )      
        (user-error "No subtree to extract; aborting")))

    (defun weiss-denote-consult--find-notes-generator (config)
      "Generate config for finding notes via consult"
      (let ((name (plist-get config :name))
            (char (plist-get config :char))
            (dir (expand-file-name (plist-get config :dir)))
            (extra-dirs (-map #'expand-file-name (plist-get config :extra-dirs)))
            (keywords (plist-get config :keywords))
            (ask-subdir (plist-get config :ask-subdir))
            )
        (-> config
            (-copy)
            (plist-put :dir dir)
            (plist-put
             :source 
             `(
               :name     ,name
               :narrow   ,char
               :category note
               :face     consult-file
               :hidden nil
               :new ,(lambda (cand)
                       (denote cand keywords nil
                               (if (eq dir denote-directory)
                                   (denote--dir "misc" "notes")
                                 (concat dir "/notes"))
                               nil nil
                               )) 
               :action ,(lambda (arg) (find-file (expand-file-name arg denote-directory)))
               :items ,(lambda () (-flatten (-map #'weiss-denote--list-notes (cons dir extra-dirs)) ))
               :state ,(weiss-consult-file-state-under-dir denote-directory)
               ))
            )      
        ))
    
    (defun weiss-denote-consult--link-notes-generator (config)
      "Generate config for linking notes via consult"
      (let ((name (plist-get config :name))
            (char (plist-get config :char))
            (dir (expand-file-name (plist-get config :dir)))
            (extra-dirs (-map #'expand-file-name (plist-get config :extra-dirs)))
            (keywords (plist-get config :keywords))
            (ask-subdir (plist-get config :ask-subdir))
            )
        (-> config
            (-copy)
            (plist-put :dir dir)
            (plist-put
             :source 
             `(
               :name     ,name
               :narrow   ,char
               :category note
               :face     consult-file
               :hidden nil
               :new ,(lambda (cand)
                       (unless (denote-filename-is-note-p (buffer-file-name))
                         (user-error "The current file is not a note"))
                       (let* ((command (lambda () (interactive)
                                         (denote
                                          (or weiss-denote-consult--region-text cand)
                                          keywords nil (concat dir "/notes") nil nil)))
                              (type (denote-filetype-heuristics (buffer-file-name)))
                              (path (denote--command-with-features command nil nil :save :in-background))
                              (description (or weiss-denote-consult--region-text cand)))
                         (denote-link path type description))
                       )
               :action ,(lambda (arg)
                          (let* ((file (expand-file-name arg denote-directory))
                                 (title (denote--retrieve-title-or-filename file 'org))
                                 )
                            (denote-link
                             file 'org
                             (or weiss-denote-consult--region-text title)
                             )
                            ))
               :items ,(lambda () (-flatten (-map #'weiss-denote--list-notes (cons dir extra-dirs)) ))
               ))
            )      
        ))

    (defun weiss-denote-consult--files-generator (config)
      "Generate config for denote files via consult"
      (let ((name (plist-get config :name))
            (char (plist-get config :char))
            (dir (expand-file-name (plist-get config :dir)))
            (extra-dirs (-map #'expand-file-name (plist-get config :extra-dirs)))
            (keywords (plist-get config :keywords))
            (ask-subdir (plist-get config :ask-subdir))
            )
        (-> config
            (-copy)
            (plist-put :dir dir)
            (plist-put
             :source 
             `(
               :name     ,name
               :narrow   ,char
               :category note
               :face     consult-file
               :hidden nil
               :sort nil
               :items ,(lambda () (-flatten (-map #'weiss-denote--list-notes (cons dir extra-dirs)) ))
               ))
            )      
        ))
    
    (let ((scala-dir (denote--dir "scala"))
          (haskell-dir (denote--dir "haskell"))
          (pa-dir (denote--dir "lectures" "Probability_and_Algorithms"))
          (ct-dir (denote--dir "lectures" "concurrency_theory"))
          (ml-dir (denote--dir "lectures" "machine_learning2"))
          (misc-dir (denote--dir "misc"))
          (math-dir (denote--dir "math"))
          (academic-dir (denote--dir "academic"))
          )
      (setq weiss-denote-consult-source-config
	        `(
              (:name "scala" :char ?s :dir ,scala-dir :keywords ("scala"))
              (:name "haskell" :char ?h :dir ,haskell-dir :keywords ("haskell"))
              (:name "academic" :char ?a :dir ,academic-dir :keywords ("academic"))
              (:name "math"
                     :char ?m
                     :dir ,math-dir
                     :keywords ("math" "draft"))
              (:name "all" :char ?  :dir ,misc-dir :extra-dirs ,(list denote-directory))
              )
            )
      )
    
    (setq weiss-denote-consult-find-notes-config
          (-map
           #'weiss-denote-consult--find-notes-generator
           weiss-denote-consult-source-config)        
          )

    (setq weiss-denote-consult-link-notes-config
          (-map
           #'weiss-denote-consult--link-notes-generator
           weiss-denote-consult-source-config)        
          )

    (setq weiss-denote-consult-files-config
          (-map
           #'weiss-denote-consult--files-generator
           weiss-denote-consult-source-config)        
          )

    (defun weiss-denote-consult--generate-source-by-config (configs)
      "DOCSTRING"
      (interactive)
      (let* ((cur-dir (expand-file-name default-directory))
             (idx (or (--find-index (s-starts-with? (plist-get it :dir) cur-dir) configs)
                      (- (length configs) 1))))
        (progn
          (--map-indexed (if (eq idx it-index)
                             (-> it
                                 (plist-get :source)
                                 (-copy)
                                 (plist-put :hidden nil)
                                 )
                           (-> it
                               (plist-get :source)
                               (-copy)
                               (plist-put :hidden t)
                               )
                           )
                         configs)
          )      
        )
      )

    (defun weiss-denote-consult--get-dir-by-name (name)
      "DOCSTRING"
      (plist-get
       (--find (string= (plist-get it :name) name) weiss-denote-consult-source-config)
       :dir))
    
    (defvar weiss-denote-consult--region-text nil)  
    (defun weiss-denote-consult ()
      "DOCSTRING"
      (interactive)
      (let ((initial (when (weiss-region-p)
                       (s-downcase (buffer-substring-no-properties (region-beginning) (region-end)))))
            )
        (when initial
          (deactivate-mark)
          (delete-other-windows)
          (weiss-split-window-dwim)
          (other-window 1)
          )
        (consult--multi (weiss-denote-consult--generate-source-by-config weiss-denote-consult-find-notes-config)
                        :initial initial 
                        :require-match
                        (confirm-nonexistent-file-or-buffer)
                        :prompt "Notes: "
                        :history 'consult-denotes-history
                        :add-history (seq-some #'thing-at-point '(region symbol))) 
        )    
      )
    
    (defun weiss-denote-consult-link-notes ()
      "DOCSTRING"
      (interactive)
      (setq weiss-denote-consult--region-text
            (when (weiss-region-p)
              (delete-and-extract-region (region-beginning) (region-end))))
      (consult--multi
       (weiss-denote-consult--generate-source-by-config
        weiss-denote-consult-link-notes-config)
       :initial (when weiss-denote-consult--region-text
                  (s-downcase weiss-denote-consult--region-text)) 
       :require-match (confirm-nonexistent-file-or-buffer)
       :prompt "Link Notes: "
       :history 'consult-denotes-history
       :add-history (seq-some #'thing-at-point '(region symbol))))


    (defun weiss-denote-link-format-heading-description (file-text heading-text)
      "Return description for FILE-TEXT with HEADING-TEXT at the end."
      (completing-read
       "Choose link description format: "
       (list heading-text (format "%s::%s" file-text heading-text) file-text)
       )
      )
    (advice-add 'denote-link-format-heading-description :override #'weiss-denote-link-format-heading-description)

    (defun weiss-denote-consult-link ()
      "DOCSTRING"
      (interactive)
      (if current-prefix-arg
          (call-interactively 'denote-org-extras-link-to-heading)
        (call-interactively 'weiss-denote-consult-link-notes)
        )
      )

    (defun weiss-denote-file-prompt (&optional files-matching-regexp)
      "DOCSTRING"
      (interactive)
      (let ((weiss-denote--files-matching-regexp files-matching-regexp)
            (returned (consult--multi
                       (weiss-denote-consult--generate-source-by-config
                        weiss-denote-consult-files-config)
                       :require-match t
                       :prompt "Denote files: "
                       :history 'consult-denotes-history
                       :add-history (seq-some #'thing-at-point '(region symbol)))))
        (expand-file-name (car returned) denote-directory)      
        )
      )
    (advice-add 'denote-file-prompt :override #'weiss-denote-file-prompt)
    )
  )

(provide 'weiss_consult_denote)
