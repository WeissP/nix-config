(defun font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))

(defun font-family-available-p (family)
  "Check if font with FONT-NAME is available."
  (-filter (lambda (s) (cl-search family s))
           (font-family-list)
           )
  )

;; (setq use-default-font-for-symbols t)

(defun with-font (s)
  "DOCSTRING"
  (font-spec :family  s)
  )


(defun patch-fonts ()
  "DOCSTRING"
  (interactive)
  (set-fontset-font t 'symbol (font-spec :family "Noto Sans" :weight 'normal :height 1.5) nil  nil)
  (set-fontset-font t 'symbol (with-font "Noto Sans symbols") nil 'prepend)
  (set-fontset-font t 'symbol (with-font "Noto Sans symbols 2") nil 'prepend)
  (set-fontset-font t 'symbol (with-font "Noto Sans Math") nil 'prepend)
  (set-fontset-font t 'symbol (with-font "Noto Color Emoji") nil 'prepend)
  )

(when (display-graphic-p)
  (patch-fonts)

  ;; Specify font for Chinese characters
  ;; (cl-loop for font in '("FZPingXianYaSongS-R-GB" "WenQuanYi Micro Hei" "Microsoft Yahei" "LXGW WenKai")
  ;;          when (font-installed-p font)
  ;;          return (set-fontset-font t '(#x4e00 . #x9fff) font))
  )
;; (set-fontset-font t ?⇐ (with-font "Noto Sans Math") nil nil)

(provide 'weiss_ui_font)

