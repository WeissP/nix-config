(with-eval-after-load 'citar-embark
  (wks-define-key
   citar-embark-map
   ""
   '(
     ("x" . weiss-citar-xdg-open-files)
     ))

  (wks-define-key
   citar-embark-citation-map
   ""
   '(
     ("x" . weiss-citar-xdg-open-files)
     ))
  )

(provide 'weiss_citar-embark_keybindings)
