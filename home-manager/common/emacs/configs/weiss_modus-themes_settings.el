(with-eval-after-load 'modus-themes
  (setopt
   modus-themes-mixed-fonts t
   modus-themes-italic-constructs nil
   modus-themes-bold-constructs t   
   )

  (setq modus-themes-completions '((matches . (heavy))
                                   (selection . (semibold))
                                   ))

  (setopt modus-themes-common-palette-overrides
          '((border-mode-line-active unspecified)
            (border-mode-line-inactive unspecified)
            (bg-mode-line-active bg-sage)
            (bg-line-number-inactive unspecified)
            (bg-line-number-active bg-sage)
            (bg-tab-bar unspecified)
            (bg-tab-current bg-sage)
            (bg-tab-other bg-main)
            (fringe unspecified)
            (bg-paren-match bg-magenta-intense)
            (comment fg-dim)
            ))
  
  (setopt modus-operandi-tinted-palette-overrides
          '(
            (fg-region unspecified)
            (bg-region bg-sage)
            )
          )

  (defun weiss-modus-patch-faces (&rest args)
    "DOCSTRING"
    (interactive)
    (patch-fonts)
    (when (featurep 'weiss_wks_select-mode)
      (setq mark-select-mode-color (modus-themes-get-color-value 'bg-hover-secondary))
      (setq mark-non-select-mode-color (modus-themes-get-color-value 'bg-sage))
      (weiss-select-mode-check-region-color)
      )
    (when (featurep 'weiss_hl-line_settings)
      (modus-themes-with-colors
        (custom-set-faces
         `(box-hl-line
           ((t :box (:line-width (-1 . -2) :color ,bg-dim :style nil))))       
         `(normal-hl-line
           ((t (:background ,bg-sage))))
         )
        )
      )
    (when (featurep 'snails)
      (modus-themes-with-colors
        (custom-set-faces
         `(snails-select-line-face
           ((t :background ,bg-sage)))       
         `(snails-content-buffer-face
           ((t :height 120 :foregorund ,fg-main :background ,bg-main)))
         `(snails-input-buffer-face
           ((t (:height 200 :foregorund ,fg-main :background ,bg-main))))
         )
        )
      )
    (modus-themes-with-colors 
      (custom-set-faces
       '(font-lock-keyword-face
         ((t (:weight heavy :slant italic))))
       `(font-lock-builtin-face
         ((t (:slant italic :foreground ,fg-dim))))
       `(underline
         ((t
           (:weight normal :underline t :foreground ,underline-link))))
       `(org-verbatim
         ((t (:inherit (default) :height 0.9 :underline nil :background ,bg-dim))))
       )
      )
    )

  (add-hook 'modus-themes-after-load-theme-hook #'weiss-modus-patch-faces)
  (add-hook 'circadian-after-load-theme-hook #'weiss-modus-patch-faces)

  (with-eval-after-load 'circadian
    (setq circadian-themes '(("8:00" . modus-operandi-tinted)
                             ("20:00" . modus-vivendi-tinted)))
    (circadian-setup)
    )
  )

(provide 'weiss_modus-themes_settings)
