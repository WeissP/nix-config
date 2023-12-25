(with-eval-after-load 'modus-themes
  (setq modus-themes-mixed-fonts t
        modus-themes-italic-constructs nil)

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
            ))
  
  (setopt modus-operandi-tinted-palette-overrides
          '(
            (fg-region unspecified)
            (builtin fg-main)
            (comment fg-dim)
            (constant blue)
            (fnname green-warmer)
            (keyword green-cooler)
            (preprocessor green)
            (docstring green-faint)
            (string magenta-cooler)
            (type cyan-warmer)
            (variable blue-warmer)
            )
          )

  (defun weiss-modus-patch-faces ()
    "DOCSTRING"
    (interactive)
    (patch-fonts)
    (setq mark-select-mode-color (modus-themes-get-color-value 'bg-hover-secondary))
    (setq mark-non-select-mode-color (modus-themes-get-color-value 'bg-sage))
    (when (featurep 'weiss_hl-line_settings)
      (custom-set-faces
       (modus-themes-with-colors 
         `(box-hl-line
           ((t :box (:line-width (-1 . -2) :color "#ededed" :style nil))))       
         `(normal-hl-line
           ((t (:background ,bg-sage))))
         )
       )
      )
    (custom-set-faces
     (modus-themes-with-colors 
       '(default
         ((t
           (:foundry "SAJA" :family "Cascadia Code PL" :height 120))))
       `(bold
         ((t
           (:weight demibold))))
       `(italic
         ((t
           (:weight normal :underline nil :slant italic :height 0.98 :foreground ,fg-dim))))
       `(underline
         ((t
           (:weight normal :underline t :foreground ,underline-link))))
       `(org-verbatim
         ((t (:inherit (default) :height 0.9 :underline nil :background ,fg-dim))))
       )
     )
    )

  (add-hook 'modus-themes-after-load-theme-hook #'weiss-modus-patch-faces)
  (add-hook 'circadian-after-load-theme-hook #'weiss-modus-patch-faces)

  (with-eval-after-load 'circadian
    (setq circadian-themes '(("9:00" . modus-operandi-tinted)
                             ("20:00" . modus-vivendi-tinted)))
    (circadian-setup)
    )
  )

(provide 'weiss_modus-themes_settings)
