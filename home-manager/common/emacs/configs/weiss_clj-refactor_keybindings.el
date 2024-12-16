(setq wks-clj-refactor-vanilla-mode-map (make-sparse-keymap))
(set-keymap-parent wks-clj-refactor-vanilla-mode-map wks-vanilla-mode-map)

(with-eval-after-load 'clj-refactor
  (wks-unset-key clj-refactor-map '("/"))
  (wks-define-key
   wks-clj-refactor-vanilla-mode-map ""
   '(
     ("/" . cljr-slash)
     )
   )
  (setq-mode-local
   clojure-mode
   wks-vanilla-mode-map wks-clj-refactor-vanilla-mode-map
   )
  )

(provide 'weiss_clj-refactor_keybindings)
