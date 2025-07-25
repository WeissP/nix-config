(setq pdf-view-restore-filename "~/.emacs.d/.pdf-view-restore")

(defun weiss-pdf-view-restore ()
  "Restore page only if page is valid."
  (when (derived-mode-p 'pdf-view-mode)
    ;; This buffer is in pdf-view-mode
    (let ((page (pdf-view-restore-get-page)))
      (when (and page (<= page (pdf-cache-number-of-pages)))
        (pdf-view-goto-page page)))))

(with-eval-after-load 'pdf-view-restore

  (advice-add 'pdf-view-restore :override #'weiss-pdf-view-restore)

  (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode)
  )


;; parent: 
(provide 'weiss_pdf-view-restore_settings)
