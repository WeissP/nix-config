(defvar auto-annotate-p nil)
(defun weiss-enable-annotate-mode (&rest args)
  "DOCSTRING"
  (interactive)
  (when auto-annotate-p (annotate-mode 1))
  )

(with-eval-after-load 'annotate
  (setq
   annotate-file "~/Documents/emacs-annotations"
   annotate-endline-annotate-whole-line t
   )
  (setq
   annotate-highlight-faces '((:underline "#bec074")
                              (:underline "#74bec0")
                              (:underline "#d883d6"))
   )

  (add-hook 'find-file-hook #'weiss-enable-annotate-mode)
  )

(provide 'weiss_annotate_settings)
