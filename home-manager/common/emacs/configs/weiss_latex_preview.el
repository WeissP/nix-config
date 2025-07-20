(defun weiss-latex-buffer-preview ()
  "If current-prefix-arg then remove preview, else preview all"
  (interactive)
  (if current-prefix-arg
      (preview-clearout-buffer)
    (let ((text (buffer-substring-no-properties 1 (min 100 (point-max)))))    
      (if (or (string-match "begin{tikzpicture}" text)
              (string-match "begin{forest}" text))
          (let ((buffer-file-name nil))
            (if current-prefix-arg
                (preview-clearout-buffer)
              (message "%s" "preview-buffer")
              (preview-buffer)))
        (weiss-org-preview-latex-and-image)
        )))
  )

(with-eval-after-load 'latex
  (eval-after-load "preview"
    '(add-to-list 'preview-default-preamble "\\PreviewEnvironment{tikzpicture}" t)
    )
  )


(provide 'weiss_latex_preview)
