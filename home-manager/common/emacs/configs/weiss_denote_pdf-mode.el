(defun weiss-denote-pdf--find-all-notes-in-page (page)
  "DOCSTRING"
  (interactive)
  (let ((dir weiss--denote-location))
    (seq-filter
     (lambda (file)
       (and (denote-file-has-identifier-p file)
            (denote-file-has-signature-p file)
            (member
             page
             (-map #'string-to-number (s-split "=" (denote-retrieve-filename-signature file))) )
            ))
     (directory-files-recursively
      dir
      directory-files-no-dot-files-regexp
      ))
    ))

(defun weiss-denote-pdf--open-files (files)
  "DOCSTRING"
  (interactive)
  (delete-other-windows)
  (-each-indexed files
    (lambda (idx file)
      (if (eq idx 0)
          (weiss-split-window-dwim)
        (split-window-vertically)
        )
      (other-window 1)
      (find-file file)
      ))
  (other-window 1)
  (balance-windows)
  )

(defun weiss-test ()
  "DOCSTRING"
  (interactive)
  (message ": %s" (weiss-denote-pdf--find-all-notes-in-page
                   (pdf-view-current-page)
                   ))
  )

(defun weiss-denote-pdf-open-files-cur-page ()
  "DOCSTRING"
  (interactive)
  (when-let ((files (weiss-denote-pdf--find-all-notes-in-page
                     (pdf-view-current-page)
                     )))
    (weiss-denote-pdf--open-files (-take 4 files)))    
  )  

(defun weiss-denote-pdf-mode-enable ()
  "DOCSTRING"
  (interactive)
  (setq weiss-denote-pdf-mode-p t)  
  (add-hook 'pdf-view-after-change-page-hook #'weiss-denote-pdf-open-files-cur-page nil t)
  (call-interactively 'weiss-denote-pdf-open-files-cur-page)
  )

(defun weiss-denote-pdf-mode-disable ()
  "DOCSTRING"
  (interactive)
  (setq weiss-denote-pdf-mode-p nil)
  (remove-hook 'pdf-view-after-change-page-hook #'weiss-denote-pdf-open-files-cur-page t)
  )

(with-eval-after-load 'denote
  (with-eval-after-load 'pdf-view
    (defvar weiss-denote-pdf-mode-p nil "nil")

    (define-minor-mode weiss-denote-pdf-mode
      "weiss-denote-pdf-mode"
      :init-value nil
      :lighter " DenotePDF"
      :group 'weiss-denote-pdf-mode
      (if weiss-denote-pdf-mode
          (weiss-denote-pdf-mode-enable)
        (weiss-denote-pdf-mode-disable)))

    (wks-define-key
     pdf-view-mode-map ""
     '(
       ("p" .  weiss-denote-pdf-mode)    
       )
     )
    )
  )

(provide 'weiss_denote_pdf_mode)
