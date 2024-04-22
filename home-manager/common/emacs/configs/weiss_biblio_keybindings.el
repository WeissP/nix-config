(wks-define-key
 wks-leader-keymap
 "<end>"
 '(
   ("b" . crossref-lookup)
   ("d" . biblio-doi-insert-bibtex)
   ))

(with-eval-after-load 'biblio

  )

(provide 'weiss_biblio_keybindings)
