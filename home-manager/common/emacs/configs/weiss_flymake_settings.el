(defun weiss-flymake-dwim ()
  "DOCSTRING"
  (interactive)
  (if  current-prefix-arg
      (call-interactively 'flymake-show-project-diagnostics)
    (call-interactively 'flymake-show-buffer-diagnostics)))

(with-eval-after-load 'flymake
  (add-hook 'weiss-lint-hook #'flymake-start)
  (setq flymake-no-changes-timeout nil)

  (with-eval-after-load 'embark
    (setq embark-target-finders (remove 'embark-target-flymake-at-point embark-target-finders))
    )
  )

(provide 'weiss_flymake_settings)
