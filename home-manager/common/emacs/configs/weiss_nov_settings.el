(defun weiss-nov-setup ()
  "DOCSTRING"
  (interactive)
  (setq nov-text-width t)
  ;; (set-background-color "#f8fd80")
  ;; (set-background-color "#eddd6e")
  ;; (set-background-color "#edd1b0")
  ;; (set-background-color "beige")
  (face-remap-add-relative 'variable-pitch :height 150)
  (setq line-spacing 10)
  ;; (visual-line-mode -1)
  (visual-line-mode 1)
  (visual-fill-column-mode 1)

  (setq visual-fill-column-center-text t)
  (setq visual-fill-column-width (floor (/ (window-total-width) 1.2)))
  )

(defun weiss-store-nov-link (beg end)
  "DOCSTRING"
  (interactive "r")
  (let ((desc (when (use-region-p) (buffer-substring-no-properties beg end))))
    (call-interactively 'org-store-link)
    (setq
     org-stored-links 
     (-update-at 0 (lambda (link) (list (car link) (or desc (cadr link))) ) org-stored-links))
    (call-interactively 'weiss-select-mode-turn-off)
    ))

(defun weiss-nov-explain-word (beg end)
  "DOCSTRING"
  (interactive "r")
  (if (use-region-p)
      (let* ((word (buffer-substring-no-properties beg end))
             (context (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
             (b (get-buffer-create (format "Explaining: %s" word)))
             (script-dir (getenv "SCRIPTS_DIR"))
             (resize-mini-windows nil)
             )
        (call-interactively 'weiss-select-mode-turn-off)
        (message "querying %S ..." word)
        (shell-command
         (format "nu %s/explain.nu %S --context %S --save-dir /home/weiss/Documents/words" script-dir word context)
         b
         )          
        (switch-to-buffer-other-window b)
        (special-mode)
        )
    (message "Please select a word!")
    )
  )

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(with-eval-after-load 'nov
  (add-hook 'nov-mode-hook 'weiss-nov-setup)

  )

(provide 'weiss_nov_settings)

