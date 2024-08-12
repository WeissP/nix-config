;; -*- lexical-binding: t -*-

(setq
 denote-directory weiss/notes-dir
 denote-prompts '(subdirectory title signature keywords)
 denote-rename-buffer-format "%t %s"
 denote-backlinks-show-context t
 denote-org-extras-dblock-file-contents-separator "\n⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊⠊\n"
 denote-excluded-directories-regexp "ltximg"
 denote-rename-no-confirm t 
 )

(defun denote--dir (&rest segs)
  "DOCSTRING"
  (interactive)
  (apply #'concat (-map #'file-name-as-directory (cons denote-directory segs)))
  )

(add-hook 'emacs-startup-hook
          #'(lambda ()
              (require 'denote-rename-buffer)
              (denote-rename-buffer-mode 1)))

(setq denote-file-name-letter-casing
      '((title . downcase)
        (signature . verbatim)
        (keywords . verbatim)
        (t . downcase)))



(with-eval-after-load 'denote
  (with-eval-after-load 'org
    (require 'denote-org-extras)
    (require 'denote-journal-extras)
    )
  
  (denote-extract-keywords-from-path   "/home/weiss/nix-config/home-manager/common/emacs/configs/weiss_denote_settings.el")

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
      (delete-other-windows)
      (weiss-split-window-dwim)
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
  (advice-add 'denote-org-extras-dblock--get-file-contents :override #'weiss-denote-org-dblock--get-file-contents)
  ;; (advice-remove 'denote-org-extras-dblock--get-file-contents #'weiss-denote-org-dblock--get-file-contents)

  
  (defun weiss-denote-journal-setup ()
    (interactive)
    (call-interactively 'weiss-enable-rime)
    (wks-vanilla-mode-enable)
    )

  (add-hook 'denote-journal-extras-hook #'weiss-denote-journal-setup)

  (defun weiss-denote--rename-buffer-service (&rest args)
    (denote-rename-buffer-rename-function-or-fallback))

  (advice-add 'denote--rename-buffer :after #'weiss-denote--rename-buffer-service)
  )


(provide 'weiss_denote_settings)

