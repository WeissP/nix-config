(with-eval-after-load 'ob-elixir
  (with-eval-after-load 'org
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((emacs-lisp . t)
       (elixir . t)))
    )
  )

(provide 'weiss_ob-elixir_settings)
