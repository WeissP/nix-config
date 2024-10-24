(defun weiss-push-mark (&rest args)
  "DOCSTRING"
  (interactive)
  (push-mark))

(defun weiss--push-mark-unless-select-mode (&rest args)
  "DOCSTRING"
  (interactive)
  (unless weiss-select-mode-p
    (weiss-push-mark)
    )
  )

(advice-add 'beginning-of-buffer :before #'weiss--push-mark-unless-select-mode)
(advice-add 'end-of-buffer :before #'weiss--push-mark-unless-select-mode)


(defun weiss-test ()
  "DOCSTRING"
  (interactive)
  (unpop-to-mark-command))

(defun unpop-to-mark-command ()
  "Unpop off mark ring. Does nothing if mark ring is empty."
  (interactive)
  ;; (unless (eq last-command 'unpop-to-mark-command)
  ;;   (set-mark-command 4)    
  ;;   )
  (when mark-ring
    (setq mark-ring (cons (copy-marker (mark-marker)) mark-ring))
    (set-marker (mark-marker) (car (last mark-ring)) (current-buffer))
    (when (null (mark t)) (ding))
    (setq mark-ring (nbutlast mark-ring))
    (goto-char (marker-position (car (last mark-ring))))))

(defun weiss-last-mark ()
  "DOCSTRING"
  (interactive)
  (unless (eq last-command 'weiss-last-mark)
    (set-mark-command 4)    
    )
  (set-mark-command 4)
  )

(defun weiss-reset-mark-ring ()
  "DOCSTRING"
  (interactive)
  (setq mark-ring nil))

(defun weiss-without-pushing-mark (fun &rest args)
  "DOCSTRING"
  (interactive)
  (cl-letf (((symbol-function 'push-mark) #'weiss-dont-push-mark))
    (apply fun args)
    ))
(advice-add 'yank :around #'weiss-without-pushing-mark)

(provide 'weiss_wks_mark-ring)
