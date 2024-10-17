(wks-define-key
 prog-mode-map
 ""
 '(
   ("t" . dogears-back)
   ))
(wks-define-key
 prog-mode-map
 "<end> d"
 '(
   ("b" . dogears-back)
   ("r" . dogears-remember)
   ("g" . dogears-go)
   ("f" . dogears-forward)
   ("l" . dogears-list)
   ("s" . dogears-sidebar)
   ))

(with-eval-after-load 'dogears  
  (wks-unset-key dogears-list-mode-map '("k"))
  (wks-define-key
   dogears-list-mode-map
   ""
   '(
     ("d" . dogears-list-delete)
     ))

  )

(provide 'weiss_dogears_keybindings)
