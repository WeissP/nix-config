(with-eval-after-load 'maxima-mode
  (when (boundp 'maxima-mode-abbrev-table)
    (clear-abbrev-table maxima-mode-abbrev-table))
  (define-abbrev-table 'maxima-mode-abbrev-table
    '(
      ("draw" "draw2d(grid=true,explicit(▮,x,1,10));")
      )
    )
  )

(provide 'weiss_abbrevs_imaxima)
