(add-hook 'dired-mode-hook (lambda () (interactive)
                             (dired-hide-details-mode 1)
                             ;; (dired-collapse-mode)
                             (dired-utils-format-information-line-mode)
                             ;; (all-the-icons-dired-mode)
                             (dired-omit-mode)
                             (setq dired-auto-revert-buffer 't)
                             ))

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
   )
  )

(provide 'weiss_dired_settings)
