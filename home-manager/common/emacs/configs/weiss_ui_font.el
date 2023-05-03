(defun font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))

(defun font-family-available-p (family)
  "Check if font with FONT-NAME is available."
  (require 'dash)
  (-filter (lambda (s) (cl-search (downcase family) (downcase s)))
           (font-family-list)
           )
  )
;; (font-installed-p "Noto Color Emoji")
;; (font-family-available-p "Apple Color Emoji")
;; (setq use-default-font-for-symbols t)

;; (-filter (lambda (s) (and (cl-search (downcase "noto") (downcase s))
;;                           (cl-search (downcase "emoji") (downcase s))
;;                           ))
;;          (font-family-list)
;;          )

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
  (set-fontset-font t 'symbol (with-font "Apple Color Emoji") nil 'prepend)

  ;; (set-fontset-font t ? (with-font "file-icons") nil nil)

  ;; Specify font for Chinese characters
  (cl-loop for font in '("WenQuanYi Micro Hei" "Microsoft Yahei" "LXGW WenKai")
           when (font-installed-p font)
           return (set-fontset-font t '(#x4e00 . #x9fff) font))
  )

(when (display-graphic-p)
  (patch-fonts)
  )
;; (font-family-available-p "icons")
;; (font-family-available-p "awesome")
;; (font-installed-p "all-the-icons")
;; (set-fontset-font t ?⇐ (with-font "Noto Sans Math") nil nil)

(provide 'weiss_ui_font)

