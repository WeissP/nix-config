(with-eval-after-load 'ammonite-term-repl
  (setq ammonite-term-repl-program "mill")
  (add-hook 'scala-mode-hook #'ammonite-term-repl-minor-mode)
  (add-hook 'ammonite-term-repl-run-hook #'weiss-after-ammonite-term-repl)
  )

(defun weiss-ammonite-formatted-region-text (start end)
  "DOCSTRING"
  (interactive "r")
  ;; (message ": %s" start)
  (save-current-buffer 
    (let ((buf (get-buffer-create "*amm-to-send*")))
      (with-current-buffer buf
        (erase-buffer))
      (call-process-region start end "scalafmt" nil `(,buf "~/.ammonite.err_out") nil "--config" "/home/weiss/projects/master_thesis/msc-thesis-bozhou-bai/join/.scalafmt_repl.conf"  "--stdin")      
      (set-buffer buf)
      (buffer-string)
      )
    )
  )

(defun weiss-test (start end)
  "DOCSTRING"
  (interactive "r")
  (message "%s"   (weiss-ammonite-formatted-region-text start end))  
  )

(defun weiss-ammonite-term-repl-send-region (start end)
  "Send the region to the ammonite buffer.
Argument START the start region.
Argument END the end region."
  (interactive "r")
  (ammonite-term-repl-check-process)
  (let ((code (weiss-ammonite-formatted-region-text start end)))
    (comint-send-string ammonite-term-repl-buffer-name "{\n")
    (comint-send-string ammonite-term-repl-buffer-name code)
    (comint-send-string ammonite-term-repl-buffer-name "\n}")
    (comint-send-string ammonite-term-repl-buffer-name "\n")
    (message
     (format "Sent: %s..." (ammonite-term-repl-code-first-line code))))
  )
(advice-add 'ammonite-term-repl-send-region :override #'weiss-ammonite-term-repl-send-region)

(defun weiss-ammonite-term-repl-send-line ()
  "DOCSTRING"
  (interactive)
  (weiss-ammonite-term-repl-send-region (line-beginning-position) (line-end-position))
  )

(defun weiss-after-ammonite-term-repl (&rest args)
  "DOCSTRING"  
  (run-with-idle-timer '3 nil #'term-line-mode)  
  )

(provide 'weiss_ammonite-term-repl_settings)

