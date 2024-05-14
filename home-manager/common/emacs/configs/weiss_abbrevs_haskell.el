(with-eval-after-load 'haskell-mode
  (when (boundp 'haskell-mode-abbrev-table)
    (clear-abbrev-table haskell-mode-abbrev-table))
  (define-abbrev-table 'haskell-mode-abbrev-table
    '(
      ("ap" "<*> " weiss--ahf)
      ("case" "case ▮ of\n  _ -> error \"TODO\"" weiss--ahf)
      ("class" "class ▮ a where\n  method :: a -> a" weiss--ahf)
      ("data" "data ▮ deriving stock (Show)" weiss--ahf)
      ("do" "do\n  ▮\n  return $ undefined" weiss--ahf)
      ("im" "import " weiss--ahf)
      ("ins" "instance ▮ Bool where" weiss--ahf)
      ("j" "Just " weiss--ahf)
      ("m" "Maybe " weiss--ahf)
      ("mb" "<$> " weiss--ahf)
      ("mf" "<&> " weiss--ahf)
      ("nt" "newtype ▮ = { from :: Int } deriving stock (Show)" weiss--ahf)
      ("p" "pure " weiss--ahf)
      ("q" "qualified as " weiss--ahf)
      ("rt" "return $ ▮" weiss--ahf)
      ("td" "error \"TODO\"" weiss--ahf)
      ("u" "undefined" weiss--ahf)
      ("vt" "t :: ▮\nt = error \"TODO\"" weiss--ahf)
      ("wh" "where\n  ▮" weiss--ahf)
      )
    )
  )

(provide 'weiss_abbrevs_haskell)
