(with-eval-after-load 'dired-single-handed-mode
  (wks-define-key
   weiss-dired-single-handed-mode-map ""
   '(("x" . hydra-dired-quick-sort/body)
     ("d" . next-line)
     ("e" . previous-line)
     ("f" . weiss-single-hand-play-movie)
     ("g" .
      (weiss-dired-single-handed-open-dir
       (dired-find-alternate-file)
       (weiss-dired-single-handed-mode)))
     ("q" . weiss-dired-single-handed-mode)
     ("s" .
      (weiss-dired-single-handed-up-dir
       (find-alternate-file "..")
       (weiss-dired-single-handed-mode)))
     ("v" . hydra-dired-filter-actress/body)
     ("V" . hydra-dired-add-tag/body)
     ("c" . hydra-dired-filter-tag/body)))
  )

(provide 'weiss_dired-single-handed-mode_keybindings)
