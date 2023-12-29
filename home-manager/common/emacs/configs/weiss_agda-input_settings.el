(setq default-input-method "Agda")

(defun weiss-init-agda-input ()
  "DOCSTRING"
  (interactive)
  (require 'agda-input)
  (agda-input-setup)
  (set-input-method "Agda")
  )

(with-eval-after-load 'agda-input
  (setq agda-input-user-translations
        '(
          ("++" "⧺")
          ("<=" "≼")
          ("sl" "⚡")
          ("se" "𝜀")
          ("of1" "①")
          ("of2" "②")
          ("of3" "③")
          ("of4" "④")
          ("-" "－")
          ("X" "❌")
          ("p" "∂")
          ))
  (agda-input-setup)
  )

(provide 'weiss_agda-input_settings)
