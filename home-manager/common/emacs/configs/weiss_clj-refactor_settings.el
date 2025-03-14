(defun my-clojure-mode-hook ()
  (clj-refactor-mode 1)
  (yas-minor-mode 1) ; for adding require/use/import statements
  ;; This choice of keybinding leaves cider-macroexpand-1 unbound
  (cljr-add-keybindings-with-prefix "C-c C-a"))

(add-hook 'clojure-mode-hook #'my-clojure-mode-hook)

(with-eval-after-load 'clj-refactor
  (add-to-list 'corfu-auto-commands 'cljr-slash)

  (setq cljr-hotload-dependencies nil)
  )



(provide 'weiss_clj-refactor_settings)
