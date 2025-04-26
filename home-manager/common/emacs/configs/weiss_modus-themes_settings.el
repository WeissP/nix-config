(setq custom-safe-themes t)

(setq modus-themes-headings
      '((1 . ( variable-pitch 1.3))
        (t . 1.2)))

(setq modus-themes-completions '((matches . (heavy))
                                 (selection . (semibold))
                                 ))

(with-eval-after-load 'modus-themes
  (setopt
   modus-themes-mixed-fonts t
   modus-themes-italic-constructs nil
   modus-themes-bold-constructs t   
   )

  (setopt modus-themes-common-palette-overrides
          '((border-mode-line-active unspecified)
            (border-mode-line-inactive unspecified)
            (bg-mode-line-active bg-sage)
            (bg-line-number-inactive unspecified)
            (bg-line-number-active bg-sage)
            (fringe unspecified)
            (bg-paren-match bg-magenta-intense)
            (comment fg-dim)
            (fg-heading-1 fg-alt)
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
      (weiss-select-mode-reset-all-buffers-region-colors)
      )
    (when (featurep 'highlight-parentheses)
      (modus-themes-with-colors
        (setq hl-paren-colors (list rainbow-1 rainbow-2 rainbow-3 rainbow-4))))
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
       '(embark-target
         ((t (:underline t :weight normal)))))

      (custom-set-faces
       '(mode-line
         ((t (:font "M PLUS 1 Code"))))
       '(mode-line-inactive
         ((t (:font "M PLUS 1 Code"))))
       '(underline 
         ((t (:underline t :weight normal))))       
       '(font-lock-keyword-face
         ((t (:weight bold :slant italic))))
       `(font-lock-builtin-face
         ((t (:slant italic :foreground ,fg-dim))))
       `(org-document-info-keyword
         ((t (:slant italic :height 0.8 :inherit variable-pitch))))
       `(org-meta-line
         ((t (:slant oblique :height 0.7 :inherit variable-pitch))))
       `(org-drawer
         ((t (:inherit org-meta-line))))
       `(org-property-value
         ((t (:height 0.7))))
       `(org-block-begin-line
         ((t (:slant oblique :height 0.7))))
       `(org-block
         ((t (:height 1.0))))
       `(org-verbatim
         ((t (:height 1.0 :background ,bg-dim))))
       `(tab-line-tab-current
         ((t (:weight semibold :box (:style released-button)))))
       `(tab-line-tab-inactive
         ((t (:weight normal))))
       )
      )
    )

  (add-hook 'modus-themes-after-load-theme-hook #'weiss-modus-patch-faces)
  (setq modus-themes-to-toggle '(modus-operandi-tinted modus-vivendi-tinted))

  (with-eval-after-load 'circadian
    (setq calendar-latitude 49.2)
    (setq calendar-longitude 7.4)
    (setq circadian-themes '((:sunrise . modus-operandi-tinted)
                             (:sunset . modus-vivendi-tinted)))
    (setq circadian-verbose t)
    (add-hook 'circadian-after-load-theme-hook #'weiss-modus-patch-faces)
    (circadian-setup)
    )
  
  (with-eval-after-load 'darkman
    (setq darkman-themes '(:light modus-operandi-tinted :dark modus-vivendi-tinted))
    (add-hook 'darkman-mode-hook #'weiss-modus-patch-faces)
    (add-hook 'darkman-after-mode-changed-hook #'weiss-modus-patch-faces)
    (darkman-mode)
    )

  (when (eq system-type 'darwin)
    (modus-themes-load-theme 'modus-operandi-tinted)
    )
  )

(provide 'weiss_modus-themes_settings)
