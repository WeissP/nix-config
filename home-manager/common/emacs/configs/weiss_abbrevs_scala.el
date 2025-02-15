(with-eval-after-load 'scala-mode
  (when (boundp 'scala-mode-abbrev-table)
    (clear-abbrev-table scala-mode-abbrev-table))

  (define-abbrev-table 'scala-mode-abbrev-table
    '(
      ("def" "def ▮ = {\n???\n}" weiss--ahf-indent)
      ("cmt" "def comment = {\n▮\n???\n}" weiss--ahf-indent)
      ("pr" "private " weiss--ahf)
      ("for" "for {\n_ <- ▮\n} yield (???)" weiss--ahf)
      ("Option" "Option[▮]" weiss--ahf)
      ("op" "Option" weiss--ahf)
      ("if" "if (▮) {}" weiss--ahf)
      ("s" "Some" weiss--ahf)
      ("Some" "Some(▮)" weiss--ahf)
      ("v" "val ▮ = " weiss--ahf)
      ("vx" "val x = ▮" weiss--ahf)
      ("vt" "val t: ▮ = ???" weiss--ahf)
      ("l" "List" weiss--ahf)
      ("list" "List" weiss--ahf)
      )
    )
  )

(provide 'weiss_abbrevs_scala)

