(with-eval-after-load 'org-noter
  ;; there is a strange bug: Error running timer ‘org-noter--show-arrow’: (invalid-function pdf-view-current-overlay)
  ;; seems like the bug is from elc, so load the el file manually
  (load "org-noter-pdf.el")
  
  (winner-mode 1)

  (setq org-noter-notes-window-location 'horizontal-split)

  (defun weiss-org-noter-embark-action (fun &rest args)
    "DOCSTRING"
    (interactive)
    (if org-noter-notes-mode
        (call-interactively 'org-noter-sync-current-note)
      (apply fun args)
      )
    )
  (advice-add 'embark-org-heading-default-action :around #'weiss-org-noter-embark-action)
  
  (defun weiss-org-noter-insert-note ()
    "DOCSTRING"
    (interactive)
    (org-noter-insert-precise-note-toggle-no-questions t)
    )
  )

(provide 'weiss_org-noter_settings)
