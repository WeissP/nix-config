(with-eval-after-load 'org-noter
  ;; there is a strange bug: Error running timer ‘org-noter--show-arrow’: (invalid-function pdf-view-current-overlay)
  ;; seems like the bug is from elc, so load the el file manually
  (load "org-noter-pdf.el")
  
  (winner-mode 1)

  (setq org-noter-notes-window-location 'horizontal-split)
  )

(provide 'weiss_org-noter_settings)
