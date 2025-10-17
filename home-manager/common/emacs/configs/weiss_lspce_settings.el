(with-eval-after-load 'lspce
  (lspce-set-log-file "/tmp/lspce.log")

  (defun weiss-lspce-scala-initializationOptions ()
    (let ((options (make-hash-table :test #'equal)))
      (lspce--add-option "isHttpEnabled" t options)
      (lspce--add-option "icons" "unicode" options)
      (lspce--add-option "compilerOptions.snippetAutoIndent" "off" options)))
  
  (setq
   lspce-server-programs `(("rustic"  "rust-analyzer" "" lspce-ra-initializationOptions)
                           ("python" "pylsp" "" )
                           ("C" "clangd" "--all-scopes-completion --clang-tidy --enable-config --header-insertion-decorators=0")
                           ("java" "java" lspce-jdtls-cmd-args lspce-jdtls-initializationOptions)
                           ("haskell" "haskell-language-server" "--lsp")
                           ("scala" "metals" "")
                           )
   lspce-show-log-level-in-modeline nil
   lspce-send-changes-idle-time 0.1
   )
  )

(provide 'weiss_lspce_settings)
