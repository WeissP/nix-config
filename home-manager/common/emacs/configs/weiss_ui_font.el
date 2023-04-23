(defun font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))

(when (display-graphic-p)
  ;; Set default font
  (set-fontset-font t 'mathematical "Noto Sans Math" nil nil)
  (set-fontset-font t 'symbol "Noto Sans Math" nil nil)
  (set-fontset-font t 'symbol "Noto Color Emoji" nil 'prepend)

  ;; Specify font for Chinese characters
  (cl-loop for font in '("FZPingXianYaSongS-R-GB" "WenQuanYi Micro Hei" "Microsoft Yahei" "LXGW WenKai")
           when (font-installed-p font)
           return (set-fontset-font t '(#x4e00 . #x9fff) font))
  )
;; (font-installed-p "cascadia code")


(provide 'weiss_ui_font)
