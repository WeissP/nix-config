(with-eval-after-load 'autoinsert
  (define-auto-insert
    `(,(rx ".envrc") . "direnv")
    '(""
      "nix_direnv_manual_reload\n"
      "use flake"
      )    
    )
  )

(provide 'weiss_auto-insert_settings)
