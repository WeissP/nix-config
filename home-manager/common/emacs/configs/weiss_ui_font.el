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

(defun with-font (s)
  "DOCSTRING"
  (font-spec :family  s)
  )

(defun patch-fonts ()
  "DOCSTRING"
  (interactive)
  (set-face-attribute 'default nil :family "Monolisa Nasy" :height 100 :weight 'normal)
  (set-face-attribute 'fixed-pitch nil :height 105 :family "Monolisa Nasy")
  (set-face-attribute 'variable-pitch nil :family "Noto Serif" :height 130)
  (set-face-attribute 'bold nil :weight 'bold :height 1.0)
  (set-fontset-font t 'symbol (font-spec :family "Noto Sans" :weight 'normal :height 1.5) nil  nil)
  (set-fontset-font t 'symbol (with-font "Noto Sans symbols") nil 'prepend)
  (set-fontset-font t 'symbol (with-font "Noto Sans symbols 2") nil 'prepend)
  (set-fontset-font t 'symbol (with-font "Noto Sans Math") nil 'prepend)
  (set-fontset-font t 'symbol (with-font "Noto Color Emoji") nil 'prepend)
  (set-fontset-font t 'symbol (with-font "Apple Color Emoji") nil 'prepend)
  (set-fontset-font t ?𝒪 (with-font "STIX Two Math") nil nil)
  (set-fontset-font t ?－ (with-font "Noto Sans Mono CJK SC") nil nil)
  (set-fontset-font t ?＋ (with-font "Noto Sans Mono CJK SC") nil nil)
  (set-fontset-font t ?⚡ (with-font "Noto Sans symbols") nil nil)
  (set-fontset-font t ?↔ (with-font "Noto Sans symbols") nil nil)

  ;; Specify font for Chinese characters
  (cl-loop for font in '("WenQuanYi Micro Hei" "Microsoft Yahei" "LXGW WenKai")
           when (font-installed-p font)
           return (set-fontset-font t '(#x4e00 . #x9fff) font))
  )

(when (display-graphic-p)
  (patch-fonts)
  )

(provide 'weiss_ui_font)

