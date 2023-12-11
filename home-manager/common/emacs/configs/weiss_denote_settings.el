;; -*- lexical-binding: t -*-

(with-eval-after-load 'denote
  (with-eval-after-load 'org
    (require 'denote-org-dblock)
    (require 'denote-journal-extras)
    )
  
  (setq denote-file-name-letter-casing
        '((title . downcase)
          (signature . verbatim)
          (keywords . verbatim)
          (t . downcase)))

  (setq
   denote-prompts '(subdirectory title signature keywords)
   denote-rename-buffer-format "%t%s_%k"
   denote-backlinks-show-context t
   )
  
  (with-eval-after-load 'denote-rename-buffer-with-title
    (denote-rename-buffer-mode 1)
    )
  
  (defun weiss-denote-pdf-note ()
    "DOCSTRING"
    (interactive)
    (call-interactively 'org-store-link)
    (let ((keywords (-concat weiss--denote-keywords '("pdf" "draft")))
          (title (if (pdf-view-active-region-p)
                     (replace-regexp-in-string
                      "\n" " "
                      (mapconcat 'identity (pdf-view-active-region-text) ? ))
                   "slides"))
          (pdf-page (number-to-string (pdf-view-current-page)))
          (text (weiss-extract-text-from-current-pdf-page))
          )
      (delete-other-windows)
      (weiss-split-window-dwim)
      (other-window 1)
      (denote title keywords nil weiss--denote-location nil nil pdf-page)
      (call-interactively 'org-insert-last-stored-link)
      (ignore-errors (weiss-init-agda-input))
      (save-buffer)
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
          (denote heading
                  (--> tags
                       (-remove (lambda (tag) (member tag '("note" "uni" "Machine" "Learning" "math"))) it)
                       (-concat it '("ml"))
                       (-distinct it)
                       )
                  'org
                  "~/Documents/notes/lectures/machine_learning2/notes/"
                  (or
                   ;; Check PROPERTIES drawer for :created: or :date:
                   (org-element-property :CREATED element)
                   (org-element-property :DATE element)
                   ;; Check the subtree for CLOSED
                   (org-element-property :raw-value
                                         (org-element-property :closed element))))          
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

  (add-hook 'denote-journal-extras-hook #'weiss-enable-rime)
  (add-hook 'denote-journal-extras-hook #'wks-vanilla-mode-enable)
  )


(provide 'weiss_denote_settings)

