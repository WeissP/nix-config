(defun weiss-citar-xdg-open-files (citekey)
  "Open a file with xdg-open"
  (interactive (list (citar-select-ref)))
  (citar-file-open-external
   (cdr (citar--select-resource citekey :files t))))

(with-eval-after-load 'citar-embark
  (citar-embark-mode)
  )

(provide 'weiss_citar-embark_settings)
