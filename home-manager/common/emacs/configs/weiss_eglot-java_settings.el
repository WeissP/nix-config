
(with-eval-after-load 'eglot-java
  (setq eglot-java-eglot-server-programs-manual-updates t)
  (add-hook 'java-mode-hook 'eglot-java-mode)  
  ;; (with-eval-after-load 'eglot-java
  ;;   (define-key eglot-java-mode-map (kbd "C-c l n") #'eglot-java-file-new)
  ;;   (define-key eglot-java-mode-map (kbd "C-c l x") #'eglot-java-run-main)
  ;;   (define-key eglot-java-mode-map (kbd "C-c l t") #'eglot-java-run-test)
  ;;   (define-key eglot-java-mode-map (kbd "C-c l N") #'eglot-java-project-new)
  ;;   (define-key eglot-java-mode-map (kbd "C-c l T") #'eglot-java-project-build-task)
  ;;   (define-key eglot-java-mode-map (kbd "C-c l R") #'eglot-java-project-build-refresh))
  ;; (eglot-java-init)
  )


(provide 'weiss_eglot-java_settings)
