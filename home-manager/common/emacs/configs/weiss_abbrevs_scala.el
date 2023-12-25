(with-eval-after-load 'scala-mode
  (when (boundp 'scala-mode-abbrev-table)
    (clear-abbrev-table scala-mode-abbrev-table))

  (define-abbrev-table 'scala-mode-abbrev-table
    '(
      ("def" "def ▮ = {\n???\n}" weiss--ahf-indent)
      ("pr" "private " weiss--ahf)
      ("for" "for {\n_ <- ▮\n} yield ()" weiss--ahf)
      ("op" "Option[▮]" weiss--ahf)
      ("v" "val _ = ▮" weiss--ahf)
      ("vx" "val x = ▮" weiss--ahf)
      )
    )
  )

(provide 'weiss_abbrevs_scala)

