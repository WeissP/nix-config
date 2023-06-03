(with-eval-after-load 'ess-r-mode
  (when (boundp 'ess-r-mode-abbrev-table)
    (clear-abbrev-table ess-r-mode-abbrev-table))

  (define-abbrev-table 'ess-r-mode-abbrev-table
    '(
      ("fun" "▮ <- function(x) {}" weiss--ahf)
      ))
  )

(provide 'weiss_abbrevs_r)
