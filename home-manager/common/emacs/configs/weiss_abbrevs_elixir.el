(with-eval-after-load 'elixir-mode
  (when (boundp 'elixir-mode-abbrev-table)
    (clear-abbrev-table elixir-mode-abbrev-table))

  (define-abbrev-table 'elixir-mode-abbrev-table
    '(
      ("if" "if ▮ do\n   \nend"  weiss--ahf)
      ("def" "def ▮() do   \nend"  weiss--ahf)
      ))
  )
(provide 'weiss_abbrevs_elixir)
;; (require 'flymake-eli)
