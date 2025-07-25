(defun weiss-wucuo-spell-check-visible-region ()
  "Spell check visible region in current buffer around cursor."
  (interactive)
  (let* ((p (point))
         (beg (max (- p (/ wucuo-spell-check-region-max 2)) (point-min)))
         (end (min (+ p (/ wucuo-spell-check-region-max 2)) (point-max))))
    (if wucuo-debug (message "wucuo-spell-check-visible-region called from %s to %s; major-mode=%s" beg end major-mode))
    ;; See https://emacs-china.org/t/flyspell-mode-wucuo-0-2-0/13274/46
    ;; where the performance issue is reported.
    ;; Tested in https://github.com/emacs-mirror/emacs/blob/master/src/xdisp.c
    (font-lock-ensure beg end)
    (flyspell-region beg end)
    ))

(defun weiss-wucuo-check-buffer ()
  "DOCSTRING"
  (interactive)
  (let ((beg (point-min))
        (end (point-max)))
    (if wucuo-debug (message "wucuo-spell-check-visible-region called from %s to %s; major-mode=%s" beg end major-mode))
    ;; See https://emacs-china.org/t/flyspell-mode-wucuo-0-2-0/13274/46
    ;; where the performance issue is reported.
    ;; Tested in https://github.com/emacs-mirror/emacs/blob/master/src/xdisp.c
    (font-lock-ensure beg end)
    (flyspell-region beg end)
    ))

(with-eval-after-load 'wucuo
  (setq wucuo-personal-font-faces-to-check '(markdown-metadata-value-face markdown-header-face-1))

  (advice-add 'wucuo-spell-check-visible-region :override #'weiss-wucuo-spell-check-visible-region)

  (setq wucuo-spell-check-region-max 400)
  )

;; parent: flyspell
(provide 'weiss_wucuo_settings)
