(with-eval-after-load 'sql-indent
  (setq my-sql-indentation-offsets-alist
        `(
          (in-block ++)
          (in-begin-block +)
          (block-start ++)
          (block-end 0)
          (insert-clause 0)
          ;; (in-select-clause sqlind-lineup-to-clause-end
          ;;                   sqlind-adjust-operator
          ;;                   sqlind-left-justify-logical-operator
          ;;                   sqlind-lone-semicolon)
          ;; put new syntactic symbols here, and add the default ones at the end.
          ;; If there is no value specified for a syntactic symbol, the default
          ;; will be picked up.
          ,@sqlind-default-indentation-offsets-alist))

  (add-hook 'sql-mode-hook #'sqlind-minor-mode)

  ;; Arrange for the new indentation offset to be set up for each SQL buffer.
  (add-hook 'sqlind-minor-mode-hook
            (lambda ()
              (setq sqlind-indentation-offsets-alist
                    my-sql-indentation-offsets-alist)))
  )

;; parent: 
(provide 'weiss_sql-indent_settings)
