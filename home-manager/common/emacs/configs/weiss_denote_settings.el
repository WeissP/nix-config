;; -*- lexical-binding: t -*-

(setq
 denote-directory weiss/notes-dir
 denote-prompts '(title keywords)
 denote-rename-buffer-format "%t %s" 
 denote-backlinks-show-context t
 denote-org-dblock-file-contents-separator "\n⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊\n"
 denote-excluded-directories-regexp "ltximg"
 denote-excluded-files-regexp (rx
                               (or
                                (seq (* anychar) ".tex")
                                (seq (* anychar) ".pdfpc")
                                (seq (* anychar) ".bib")
                                (seq (* anychar) ".bbl")
                                )) 
 denote-rename-confirmations nil 
 denote-dired-directories-include-subdirectories t
 )

(defun denote--dir (&rest segs)
  "DOCSTRING"
  (interactive)
  (apply #'concat (-map #'file-name-as-directory (cons denote-directory segs)))
  )

(add-hook 'emacs-startup-hook
          #'(lambda ()
              (denote-rename-buffer-mode 1)))

(defun weiss-enable-denote-or-diredfl (&rest args)
  "DOCSTRING"
  (interactive)
  (if-let* ((dirs (denote-dired--modes-dirs-as-dirs))
            ;; Also include subdirs
            ((or (member (file-truename default-directory) dirs)
                 (and denote-dired-directories-include-subdirectories
                      (seq-some
                       (lambda (dir)
                         (string-prefix-p dir (file-truename default-directory)))
                       dirs)))))
      (denote-dired-mode 1)
    (diredfl-mode 1)
    )
  )

(add-hook 'dired-mode-hook #'weiss-enable-denote-or-diredfl)


(setq denote-file-name-letter-casing
      '((title . downcase)
        (signature . verbatim)
        (keywords . verbatim)
        (t . downcase)))



(defun weiss-denote-pdf-note (&rest additional-keywords)
  "DOCSTRING"
  (interactive)
  (call-interactively 'org-store-link)
  (let ((dir (concat (file-name-as-directory weiss--denote-location)
                     "notes"))
        (keywords  (-distinct
                    (-non-nil
                     (append
                      weiss--denote-keywords
                      additional-keywords
                      (denote-extract-keywords-from-path (buffer-file-name))))))
        (title (if (pdf-view-active-region-p)
                   (replace-regexp-in-string
                    "\n" " "
                    (mapconcat 'identity (pdf-view-active-region-text) ? ))
                 "slides"))
        (pdf-page (number-to-string (pdf-view-current-page)))
        )
    (unless (= (length (window-list)) 2)
      (delete-other-windows)
      (weiss-split-window-dwim)    
      )
    (other-window 1)
    (denote title keywords nil dir nil nil pdf-page)
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
  (when (denote-file-is-note-p file)
    (with-temp-buffer
      (when add-links
        (insert
         (format "- %s\n\n"
                 (denote-format-link
                  file
                  (denote--link-get-description file)
                  'org
                  (eq add-links 'id-only)))))
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

(defun weiss-denote--rename-buffer-service (&rest args)
  (denote-rename-buffer-rename-function-or-fallback))

(defun weiss-denote--after-dblock (&rest args)
  "DOCSTRING"
  (call-interactively 'org-latex-preview)
  )

(with-eval-after-load 'denote
  (with-eval-after-load 'org
    (require 'denote-org)
    (require 'denote-journal)

    (advice-add 'org-dblock-write:denote-files :after #'weiss-denote--after-dblock)
    )

  (add-to-list 'denote-templates '(journal . ""))
  (add-hook 'denote-journal-hook #'weiss-denote-journal-setup)
  ;; (advice-add 'denote--rename-buffer :after #'weiss-denote--rename-buffer-service)
  )


(provide 'weiss_denote_settings)

