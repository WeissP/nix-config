(with-eval-after-load 'org-noter
  (winner-mode 1)

  (setq org-noter-notes-window-location
        (pcase emacs-host
          ("arch"
           ;; 'vertical-split 
           'horizontal-split 
           )
          ("mac"
           'horizontal-split
           )))
  )

(provide 'weiss_org-noter_settings)
