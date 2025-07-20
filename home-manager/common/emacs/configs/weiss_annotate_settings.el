(require 'annotate)

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
  )

(provide 'weiss_annotate_settings)
