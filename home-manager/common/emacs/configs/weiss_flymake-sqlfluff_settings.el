(require 'flymake-sqlfluff)
(with-eval-after-load 'flymake-sqlfluff
  (add-hook 'sql-mode-hook #'flymake-mode)
  (add-hook 'sql-mode-hook #'flymake-sqlfluff-load)

  (defun my-flymake-sqlfluff--get-raw-report ()
    "add general config"
    (let ((code-content (buffer-substring-no-properties (point-min) (point-max))))
      (with-temp-buffer
        (insert code-content)
        ;; run command and replace temp buffer content with command output
        (call-process-region (point-min) (point-max) (shell-quote-argument flymake-sqlfluff-program) t t nil "lint" "--config" (expand-file-name "~/.config/sqlfluff/.sqlfluff") "--dialect" (shell-quote-argument flymake-sqlfluff-dialect) "--format" "json" "-")
        (buffer-substring-no-properties (point-min) (point-max)))))

  (advice-add 'flymake-sqlfluff--get-raw-report :override #'my-flymake-sqlfluff--get-raw-report)
  )

(provide 'weiss_flymake-sqlfluff_settings)


