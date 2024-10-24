(column-number-mode 1)
;; (defun custom-modeline-mode-icon ()
;;   (format " %s"
;;           (propertize (all-the-icons-alltheicon "python" )
;;                       'display '(raise -0.1)
;;                       'face `(:height 1.2 :family ,(all-the-icons-icon-family-for-buffer)))))

(custom-set-faces
 '(mode-line ((t :box (:style released-button)))))

(setq mode-line-compact 'long)

(setq-default mode-line-format
              `(
                " "
                (:eval (if wks-vanilla-mode
                           (concat "<"
                                   (propertize "I" 'face
                                               '(:foreground "red" :weight bold))
                                   ">"
                                   )
                         "<C>"
                         ))
                "   "
                mode-line-mule-info mode-line-modified mode-line-remote
                "   "
                (,line-number-mode "L%l/")
                (,line-number-mode weiss-mode-line-buffer-line-count)
                (,column-number-mode (5 " C%c "))        
                ;; weiss-mode-line-flycheck-errors
                ;; (:eval (concat (custom-modeline-mode-icon)))
                " "
                "%e" mode-line-buffer-identification "   " 
                ;; weiss-mode-line-git
                "  " mode-line-modes mode-line-misc-info
                (vc-mode vc-mode)
                " "
                weiss-mode-line-projectile-root-dir
                mode-line-end-spaces
                ))

;; parent: ui
(provide 'weiss_modeline_settings)


