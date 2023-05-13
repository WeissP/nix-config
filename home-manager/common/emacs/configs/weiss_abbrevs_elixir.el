(with-eval-after-load 'elixir-mode
  (when (boundp 'elixir-mode-abbrev-table)
    (clear-abbrev-table elixir-mode-abbrev-table))

  (define-abbrev-table 'elixir-mode-abbrev-table
    '(
      ("if" "if ▮ do\n   \nend"  weiss--ahf)
      ("def" "def ▮() do   \nend"  weiss--ahf)
      ("defp" "defp ▮() do   \nend"  weiss--ahf)
      ("case" "case ▮ do\n  _ ->\nend"  weiss--ahf)
      ("fn" "fn ▮ ->  end"  weiss--ahf)
      ("mod" "defmodule ▮ do\n\nend"  weiss--ahf)
      ))
  )


(provide 'weiss_abbrevs_elixir)
;; (require 'flymake-eli)
