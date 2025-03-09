(defun weiss-run-aider-under-project-dir (run &rest args)
  "DOCSTRING"
  (interactive)
  (if-let ((p (project-current nil)))
      (let ((default-directory (project-root p)))
        (apply run args)
        )
    (apply run args)
    )
  )

(setq aider-popular-models '("anthropic/claude-3-7-sonnet-20250219" "o3-mini" "openrouter/deepseek/deepseek-r1" "openrouter/deepseek/deepseek-chat"))

(with-eval-after-load 'aider 
  (setq weiss-aider-basic-args
        (-concat 
         '("--config" "~/.config/aider/aider.conf.yml" 
           "--model-settings-file" "~/nix-config/home-manager/common/config_files/aider/aider.model.settings.yml" 
           ;; "--architect"
           )
         
         (-mapcat (lambda (p) (list "--set-env" (format "%s=%s" (car p) (cdr p))))
                  (list 
                   `("OPENAI_API_KEY" . ,(password-store-get-field "openai" "api"))
                   `("DEEPSEEK_API_KEY" . ,(password-store-get-field "deepseek" "api-key"))
                   `("ANTHROPIC_API_KEY" . ,(password-store-get-field "anthropic" "api-key"))
                   `("OPENROUTER_API_KEY" . ,(password-store-get-field "openrouter" "api-key"))
                   )
                  )
         )
        aider-args weiss-aider-basic-args
        )

  (advice-add
   'aider-run-aider
   :around #'weiss-run-aider-under-project-dir
   )

  (defun weiss-insert-aider-brace ()
    "DOCSTRING"
    (interactive)
    (when (and 
           (eq major-mode 'comint-mode)
           (s-starts-with? "*aider" (buffer-name) ))
      (weiss-insert-pair "{aider" "aider}" t)
      t
      ))
  (advice-add 'weiss-insert-brace :before-until #'weiss-insert-aider-brace)
  )



(provide 'weiss_aider_settings)
