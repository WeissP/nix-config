(wks-define-key
 wks-leader-keymap
 "<end>"
 '(
   ("a" . arxiv-lookup)
   ("b" . crossref-lookup)
   ("d" . biblio-doi-insert-bibtex)
   ))

(with-eval-after-load 'biblio

  )

(provide 'weiss_biblio_keybindings)
