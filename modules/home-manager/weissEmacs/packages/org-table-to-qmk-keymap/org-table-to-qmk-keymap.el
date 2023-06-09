(defvar tbl2qmk-max-row 6)
(defvar tbl2qmk-thumb-keys-max-row 3)

(defun tbl2qmk-convert ()
  "DOCSTRING"
  (interactive)
  (next-line)
  (let* ((p1 (line-beginning-position))
         p2 
         )
    (next-line (+ (* 2 tbl2qmk-max-row) (* 2 tbl2qmk-thumb-keys-max-row) 3))
    (setq p2 (line-end-position))
    (kill-new (tbl2qmk-gen-keymap (buffer-substring-no-properties p1 p2)))
    ))

(defun tbl2qmk-replace-tbl-border (x)
  "DOCSTRING"
  (interactive)
  (setq x (substring (replace-regexp-in-string " *| *" "," x) 1 -1))
  (setq x (replace-regexp-in-string ",,+" "," x))
  x)

(defun tbl2qmk-gen-keymap (tbl)
  "DOCSTRING"
  (interactive)
  (let ((ls (split-string tbl "\n" nil))
        (buf (get-buffer-create "qmk-keymap"))
        (count 1)
        (line-num 0)
        (ll (make-list tbl2qmk-max-row ""))
        (tl (make-list tbl2qmk-thumb-keys-max-row ""))
        )
    (with-current-buffer buf
      (erase-buffer)
      (dolist (x ls)
        (if (< (length x) 1)
            (progn
              (setq count (1+ count))
              (setq line-num 0)              
              )
          (cond
           ((eq count 1)
            (setq x (tbl2qmk-replace-tbl-border x))
            (setf (nth line-num ll) x)
            (setq line-num (1+ line-num))
            )
           ((eq count 2)
            (setq x (tbl2qmk-replace-tbl-border x))
            (setf (nth line-num ll) (concat (nth line-num ll) "," x))
            (setq line-num (1+ line-num))
            )
           ((eq count 3)
            (setq x (tbl2qmk-replace-tbl-border x))
            (setf (nth line-num tl) x)
            (setq line-num (1+ line-num))
            )
           ((eq count 4)
            (setq x (tbl2qmk-replace-tbl-border x))
            (setf (nth line-num tl) (concat (nth line-num tl) "," x))
            (setq line-num (1+ line-num))
            )
           (t nil)
           )
          )
        )
      (insert (mapconcat 'identity ll ",\n"))
      (insert "\n")
      (insert (mapconcat 'identity tl ",\n"))
      (goto-char (point-min))
      (while (re-search-forward ",,+" nil t)
        (replace-match ","))
      ;; (display-buffer
      ;;  buf
      ;;  '((display-buffer-below-selected display-buffer-at-bottom)
      ;;    (inhibit-same-window . t)))
      ;; (fit-window-to-buffer (window-in-direction 'below))
      (buffer-string)
      )
    )
  )

;;;###autoload
(defun tbl2qmk-convert-region ()
  "DOCSTRING"
  (interactive)
  (when (use-region-p)
    (tbl2qmk-gen-keymap (buffer-substring-no-properties (region-beginning) (region-end)))
    )
  )

(provide 'org-table-to-qmk-keymap)
