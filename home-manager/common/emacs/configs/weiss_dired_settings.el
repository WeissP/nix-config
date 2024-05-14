(with-eval-after-load 'dired-x
  (defun my-dired-omit-expunge (&optional regexp linep init-count)
    "For some reason, dired-do-kill-lines may return nil"
    (interactive "sOmit files (regexp): \nP")
    ;; Bind `dired-marker-char' to `dired-omit-marker-char',
    ;; then call `dired-do-kill-lines'.
    (if (and dired-omit-mode
             (or (called-interactively-p 'interactive)
                 (not dired-omit-size-limit)
                 (< (buffer-size) dired-omit-size-limit)
                 (progn
                   (when dired-omit-verbose
                     (message "Not omitting: directory larger than %d characters."
                              dired-omit-size-limit))
                   (setq dired-omit-mode nil)
                   nil)))
        (let ((omit-re (or regexp (dired-omit-regexp)))
              (old-modified-p (buffer-modified-p))
              (count (or init-count 0)))
          (unless (string= omit-re "")
            (let ((dired-marker-char dired-omit-marker-char))
              (when dired-omit-verbose (message "Omitting..."))
              (if (not (if linep
                           (dired-mark-if
                            (and (= (following-char) ?\s) ; Not already marked
                                 (string-match-p
                                  omit-re (buffer-substring
                                           (line-beginning-position)
                                           (line-end-position))))
                            nil)
                         (dired-mark-unmarked-files
                          omit-re nil nil dired-omit-localp
                          (dired-omit-case-fold-p (if (stringp dired-directory)
                                                      dired-directory
                                                    (car dired-directory))))))
                  (when dired-omit-verbose (message "(Nothing to omit)"))
                (setq count  (+ count
                                (or (dired-do-kill-lines
                                     nil
                                     (if dired-omit-verbose "Omitted %d line%s" "")
                                     init-count)
                                    0)))
                (force-mode-line-update))))
          ;; Try to preserve modified state, so `%*' doesn't appear in
          ;; `mode-line'.
          (set-buffer-modified-p (and old-modified-p
                                      (save-excursion
                                        (goto-char (point-min))
                                        (re-search-forward dired-re-mark nil t))))
          count)))

  (advice-add 'dired-omit-expunge :override #'my-dired-omit-expunge)
  )

(add-hook 'dired-mode-hook (lambda () 
                             (dired-hide-details-mode 1)
                             (dired-utils-format-information-line-mode)
                             (dired-omit-mode)
                             (auto-revert-mode)
                             ))

(defun weiss-dired-toggle-details ()
  "DOCSTRING"
  (interactive)
  (if (or dired-hide-details-mode dired-omit-mode)
      (progn
        (dired-hide-details-mode -1)
        (dired-omit-mode -1)
        )      
    (dired-hide-details-mode 1)
    (dired-omit-mode 1)
    )
  )

(defun weiss-show-icons-in-dired-p ()
  "Don't show icons in some Dir due to low performance"
  (interactive)
  (let ((dired-icons-blacklist '("ssh:" "porn" "/lib/" "/lib64/" "/etc/" "/usr/share/texmf-dist/tex/latex/" "/usr/"))
        r)
    (--none? (string-match-p it dired-directory) dired-icons-blacklist)
    )
  )

(with-eval-after-load 'dired
  ;; (put 'dired-find-alternate-file 'disabled nil)
  (setq
   dired-dwim-target t
   dired-recursive-deletes 'always
   dired-recursive-copies (quote always)
   dired-auto-revert-buffer t
   dired-omit-files "\\`[.]?#\\|\\`[.][.]?\\'|\\|.*aria2$\\|.*agdai$\\|^.*frag-master.*$\\|^my_tmp$\\|^\\."
   dired-listing-switches "-altGh"
   dired-mouse-drag-files t
   dired-auto-revert-buffer t
   )

  
  )

(provide 'weiss_dired_settings)
