(setq pdf-view-restore-filename "~/.emacs.d/.pdf-view-restore")

(add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode)

(with-eval-after-load 'pdf-view-restore
  (defun weiss-pdf-view-restore ()
    "Restore page only if page is valid."
    (when (derived-mode-p 'pdf-view-mode)
      ;; This buffer is in pdf-view-mode
      (let ((page (pdf-view-restore-get-page)))
        (when (and page (<= page (pdf-cache-number-of-pages)))
          (pdf-view-goto-page page)))))

  (advice-add 'pdf-view-restore :override #'weiss-pdf-view-restore)
  )


;; parent: 
(provide 'weiss_pdf-view-restore_settings)
