(with-eval-after-load 'lspce
  (lspce-set-log-file "/tmp/lspce.log")
  
  (setq
   lspce-server-programs `(("rustic"  "rust-analyzer" "" lspce-ra-initializationOptions)
                           ("python" "pylsp" "" )
                           ("C" "clangd" "--all-scopes-completion --clang-tidy --enable-config --header-insertion-decorators=0")
                           ("java" "java" lspce-jdtls-cmd-args lspce-jdtls-initializationOptions)
                           ("haskell" "haskell-language-server" "--lsp")
                           )
   lspce-show-log-level-in-modeline nil
   lspce-send-changes-idle-time 0.1
   )
  )

(provide 'weiss_lspce_settings)
