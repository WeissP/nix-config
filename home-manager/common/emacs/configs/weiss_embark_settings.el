(defun embark-default-action-in-other-window ()
  "Run the default embark action in another window."
  (interactive))
(cl-defun run-default-action-in-other-window
    (&rest rest &key run type &allow-other-keys)
  (let ((default-action (embark--default-action type)))
    (weiss-split-window-dwim) 
    (funcall run :action default-action :type type rest)))

(defun weiss-embark-copy-file-name (f)
  "DOCSTRING"
  (kill-new (f-filename f))
  )

(defun weiss-embark-eval-and-output-region ()
  "DOCSTRING"
  (interactive)
  (eval-region (region-beginning) (region-end) t)
  )

(with-eval-after-load 'embark
  (add-to-list 'display-buffer-alist
               '("\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 (display-buffer-at-bottom)
                 (window-parameters .
                                    ((no-other-window . t)
                                     (mode-line-format . none)))))

  
  (add-hook 'embark-collect-post-revert-hook
            (defun resize-embark-collect-window (&rest _)
              (when (memq embark-collect--kind '(:live :completions))
                (fit-window-to-buffer (get-buffer-window)
                                      (floor (frame-height) 2) 1))))

  (setq embark-indicators
        '(embark-minimal-indicator  ; default is embark-mixed-indicator
          embark-highlight-indicator
          embark-isearch-highlight-indicator))

  (setf (alist-get 'embark-default-action-in-other-window
                   embark-around-action-hooks)
        '(run-default-action-in-other-window))
  (define-key embark-general-map "-" #'embark-default-action-in-other-window)

  (with-eval-after-load 'vertico
    (require 'vertico-multiform)
    (add-to-list 'vertico-multiform-categories '(embark-keybinding grid))
    (vertico-multiform-mode)
    )

  (add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode)
  )

(provide 'weiss_embark_settings)
