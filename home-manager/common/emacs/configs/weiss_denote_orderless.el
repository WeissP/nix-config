(defun denote-orderless--is-orderless-filter (str)
  "check whether `str' is an orderless filter and return the filter if it is, otherwise return nil"
  (interactive)
  (let ((prefix "ol: "))
    (when (s-prefix? prefix str)
      (s-chop-left (length prefix) str)
      )
    )
  )

(defun denote-orderless-directory-files (oldfun &optional files-matching-regexp omit-current text-only exclude-regexp)
  "use orderless to filter files"
  (if-let ((ol-filter (denote-orderless--is-orderless-filter files-matching-regexp)))
      (progn
        ;; (message "ol-filter: %s" ol-filter)
        (let ((files (denote--directory-get-files)))
          (when (and omit-current buffer-file-name (denote-file-has-identifier-p buffer-file-name))
            (setq files (delete buffer-file-name files)))
          (when ol-filter
            (setq files (orderless-filter ol-filter files))
            )
          (when text-only
            (setq files (seq-filter #'denote-file-is-note-p files)))
          files)
        )
    (funcall oldfun files-matching-regexp omit-current text-only exclude-regexp)
    )
  )

(with-eval-after-load 'denote
  (with-eval-after-load 'orderless
    (advice-add 'denote-directory-files :around #'denote-orderless-directory-files)
    
    )
  )

(provide 'weiss_denote_orderless)
