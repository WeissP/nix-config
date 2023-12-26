;; -*- lexical-binding: t -*-

(with-eval-after-load 'denote
  (defun weiss-denote--list-notes (dir)
    "DOCSTRING"    
    (-map (lambda (s) (s-chop-left (length dir) s))
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
             :new ,(lambda (cand) (denote cand keywords nil (concat dir "/notes") nil nil)) 
             :action ,(lambda (arg) (find-file (expand-file-name arg dir)))
             :items ,(lambda () (weiss-denote--list-notes dir))
             :state ,(lambda ()
                       (let ((open (consult--temporary-files))
                             (state (consult--file-state)))
                         (lambda (action cand)
                           (unless cand
                             (funcall open))
                           (funcall state action
                                    (and cand (expand-file-name cand dir))))))                
             ))
          )      
      ))

  (defun weiss-denote-consult--link-notes-generator (config)
    "Generate config for linking notes via consult"
    (let ((name (plist-get config :name))
          (char (plist-get config :char))
          (dir (expand-file-name (plist-get config :dir)))
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
                     (denote--link-after-creating-subr
                      (lambda () (interactive)
                        (denote
                         (or weiss-denote-consult--region-text cand)
                         keywords nil (concat dir "/notes") nil nil))
                      (lambda (&rest args)
                        (or weiss-denote-consult--region-text cand))
                      )
                     )
             :action ,(lambda (arg)
                        (let* (
                               (file (expand-file-name arg dir))
                               (title (denote--retrieve-title-or-filename file 'org))
                               (sig (denote-retrieve-filename-signature file))
                               )
                          (denote-link
                           file 'org
                           (or weiss-denote-consult--region-text
                               (concat title sig))                           
                           )
                          ))
             :items ,(lambda () (weiss-denote--list-notes dir))
             ))
          )      
      ))

  (setq weiss-denote-consult-source-config
	    '(
          (:name "misc" :char ?d :dir "~/Documents/notes/misc/")
          (:name "scala" :char ?s :dir "~/Documents/notes/scala/" :keywords ("scala"))
          (:name "ProbAlgo"  :char ?p :dir "~/Documents/notes/lectures/Probability_and_Algorithms/" :keywords ("ProbAlgo" "draft"))
          (:name "ConcurrencyTheory" :char ?c :dir "~/Documents/notes/lectures/concurrency_theory/" :keywords ("ConcurrencyTheory" "draft"))
          (:name "ml2" :char ?m :dir "~/Documents/notes/lectures/machine_learning2/" :keywords ("ml2" "draft"))
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

  (defun weiss-denote-consult--generate-source-by-config (configs)
    "DOCSTRING"
    (interactive)
    (if-let* ((cur-dir (expand-file-name default-directory))
              (idx (--find-index (s-starts-with? (plist-get it :dir) cur-dir) configs)))
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
      (--map (plist-get it :source) configs)
      )
    )

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
  )

(provide 'weiss_denote_consult)
