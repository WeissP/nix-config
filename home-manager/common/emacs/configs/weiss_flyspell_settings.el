(defun weiss-flyspell-save-word ()
  "From https://stackoverflow.com/questions/22107182/in-emacs-flyspell-mode-how-to-add-new-word-to-dictionary"
  (interactive)
  (let ((current-location (point))
        (word (flyspell-get-word)))
    (when (consp word)
      (flyspell-do-correct 'save nil
                           (car word)
                           current-location
                           (cadr word)
                           (caddr word)
                           current-location))))

(with-eval-after-load 'flyspell
  (setq ispell-program-name "aspell")
  (setq ispell-extra-args '("--sug-mode=ultra" "--run-together" "--run-together-limit=16"))
  ;; (setq ispell-local-dictionary "en_US")
  ;; (setq ispell-local-dictionary-alist
  ;;       '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil
  ;;          ("-d" "en_US")
  ;;          nil utf-8)))
  ;; ;; new variable `ispell-hunspell-dictionary-alist' is defined in Emacs
  ;; ;; If it's nil, Emacs tries to automatically set up the dictionaries.
  ;; (when (boundp 'ispell-hunspell-dictionary-alist)
  ;;   (setq ispell-hunspell-dictionary-alist ispell-local-dictionary-alist))
  )

(provide 'weiss_flyspell_settings)
