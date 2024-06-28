;; (add-to-list 'load-path "~/.emacs.d/site-lisp/lspce/")
(require 'lspce)
(with-eval-after-load 'lspce
  (lspce-set-log-file "/tmp/lspce.log")

  (setq lspce-server-programs `(("rust"  "rust-analyzer" "" lspce-ra-initializationOptions)
                                ("python" "pylsp" "" )
                                ("C" "clangd" "--all-scopes-completion --clang-tidy --enable-config --header-insertion-decorators=0")
                                ("java" "java" lspce-jdtls-cmd-args lspce-jdtls-initializationOptions)
                                ))
  )

(provide 'weiss_lspce_settings)
