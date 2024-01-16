;; -*- lexical-binding: t -*-

(setq
 denote-prompts '(subdirectory title signature keywords)
 denote-rename-buffer-format "%t %s"
 denote-backlinks-show-context t
 denote-org-dblock-file-contents-separator "\n⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊\n"
 denote-excluded-directories-regexp "ltximg"
 )

(add-hook 'emacs-startup-hook #'(lambda () (denote-rename-buffer-mode 1)))

(setq denote-file-name-letter-casing
      '((title . downcase)
        (signature . verbatim)
        (keywords . verbatim)
        (t . downcase)))

(with-eval-after-load 'denote
  (with-eval-after-load 'org
    (require 'denote-org-dblock)
    (require 'denote-journal-extras)
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
      (previous-line)
      (call-interactively 'org-insert-last-stored-link)
      (ignore-errors (weiss-init-agda-input))
      (save-buffer)
      ))

  (defun weiss-denote-extract-summary (beginning-of-contents)
    "DOCSTRING"
    (delete-region
     (1+ (re-search-forward "^$" nil :no-error 1))
     beginning-of-contents)
    (when (re-search-forward "^\\*+ " nil :no-error 1)      
      (delete-region (pos-bol) (point-max))
      )
    (delete-blank-lines)
    )
  
  (defun weiss-denote-org-dblock--get-file-contents (file &optional no-front-matter add-links)
    "DOCSTRING"
    (interactive)
    (when (denote-file-is-note-p file)
      (with-temp-buffer
        (when add-links
          (insert
           (format "- %s\n\n"
                   (denote-format-link
                    file
                    (if (eq add-links 'id-only)
                        denote-id-only-link-format
                      denote-org-link-format)
                    (let ((type (denote-filetype-heuristics file)))
                      (if (denote-file-has-signature-p file)
                          (denote--link-get-description-with-signature file type)
                        (denote--link-get-description file type)))))))
        (let ((beginning-of-contents (point)))
          (insert-file-contents file)
          (if no-front-matter
              (delete-region
               (if (natnump no-front-matter)
                   (progn (forward-line no-front-matter) (line-beginning-position))
                 (1+ (re-search-forward "^$" nil :no-error 1)))
               beginning-of-contents)              
            (weiss-denote-extract-summary beginning-of-contents)
            )          
          (when add-links
            (indent-region beginning-of-contents (point-max) 2)))
        (buffer-string))))
  (advice-add 'denote-org-dblock--get-file-contents :override #'weiss-denote-org-dblock--get-file-contents)
  
  (defun weiss-denote-journal-setup ()
    (interactive)
    (call-interactively 'weiss-enable-rime)
    (wks-vanilla-mode-enable)
    )

  (add-hook 'denote-journal-extras-hook #'weiss-denote-journal-setup)
  )


(provide 'weiss_denote_settings)

