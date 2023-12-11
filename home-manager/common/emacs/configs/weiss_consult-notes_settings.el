(with-eval-after-load 'consult-notes
  ;; (setq consult-notes-file-dir-sources
  ;;       '(("Concurrency Theory" ?c "~/Documents/notes/lectures/concurrency_theory/notes/")
  ;;         ))
  (setq consult-notes-file-dir-sources
        '(
          ))
  (setq consult-notes-denote-display-id nil
        ;; consult-notes-file-dir-annotate-function #'consult-notes-denote--annotate
        )
  (with-eval-after-load 'denote
    (consult-notes-denote-mode)
    )
  )

(provide 'weiss_consult-notes_settings)
