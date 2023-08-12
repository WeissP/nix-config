(with-eval-after-load 'haskell-mode
  (when (boundp 'haskell-mode-abbrev-table)
    (clear-abbrev-table haskell-mode-abbrev-table))
  (define-abbrev-table 'haskell-mode-abbrev-table
    '(
      ("do" "do\n  ▮" weiss--ahf)
      ("rt" "return ▮" weiss--ahf)
      ("case" "case ▮ of\n  _ -> error \"todo\"" weiss--ahf)
      ("data" "data ▮ deriving stock (Show)" weiss--ahf)
      ("class" "class ▮ a where\n  method :: a -> a" weiss--ahf)
      ("ins" "instance ▮ Bool where" weiss--ahf)
      ("im" "import " weiss--ahf)
      ("iq" "import qualified ▮ as Q" weiss--ahf)
      ("nt" "newtype ▮ = { from :: Int } deriving stock (Show)" weiss--ahf)
      ("wh" "where\n  ▮" weiss--ahf)
      ("td" "error \"todo\"" weiss--ahf)
      )
    )
  )

(provide 'weiss_abbrevs_haskell)
