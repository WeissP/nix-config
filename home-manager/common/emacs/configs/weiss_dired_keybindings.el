(with-eval-after-load 'dired
  (advice-add 'dired-query :before #'disable-wks-vanilla-mode)
  
  (wks-unset-key dired-mode-map '("^") :numbers)
  (wks-unset-key
   dired-mode-map
   '("SPC" "g" "n" "=" "!" "a" "$" "y")
   )

  (wks-define-key
   dired-mode-map "SPC l"
   '(
     ("r" . dired-toggle-read-only)
     ("v" . weiss-dired-single-handed-mode)
     )
   )

  (wks-define-key
   dired-mode-map "<deletechar> l"
   '(
     ("r" . dired-toggle-read-only)
     ("v" . weiss-dired-single-handed-mode)
     )
   )

  (wks-define-key
   dired-mode-map "g"
   '(
     ("a" . (weiss-dired-find-audio-todos (find-file "~/Downloads/my_tmp/todos/")))
     ("d" . (weiss-dired-find-downloads (find-file "~/Downloads")))
     ("v" . (weiss-dired-find-Vorlesungen (find-file "~/Documents/Vorlesungen")))
     ("n" . (weiss-dired-find-emacs-config (find-file "~/Documents/notes/")))
     ("l" . (weiss-dired-find-lectures (find-file "~/Documents/notes/lectures/")))
     ("m" . (weiss-dired-find-media (if (eq system-type 'darwin) (find-file "/volumes/KINGSTON") (find-file "/run/media/weiss"))))
     ("p" . (weiss-dired-find-backup (find-file "/run/media/weiss/Seagate_Backup/videos/porn/")))
     ("h" . (weiss-dired-find-home (find-file "~/")))
     ("t" . (weiss-dired-find-telega (find-file "~/.telega/cache/")))
     ("e" . (weiss-dired-find-emacs-config (find-file "~/.emacs.d")))
     )
   )

  (wks-define-key
   dired-mode-map ""
   '(
     ("," . beginning-of-buffer)
     ("-" . revert-buffer)
     ("." . end-of-buffer)
     ("8" .  dired-hide-details-mode)
     ("=" .  dired-sort-toggle-or-edit)
     ("C" .  weiss-dired-rsync)
     ("D" .  weiss-dired-dragon-files)
     ("L" .  dired-do-symlink)
     ("S" .  hydra-dired-quick-sort/body)
     ("U" .  (weiss-dired-unmark-all-and-revert (dired-unmark-all-marks) (revert-buffer)))
     ("Z" .  dired-do-compress-to)
     ("\"" . dired-maybe-insert-subdir)
     ("b" .  weiss-dired-toggle-details)
     ("c" .  dired-do-copy)
     ("d" .  dired-do-delete)
     ("f" .  (weiss-dired-toggle-wdired (dired-toggle-read-only)(wks-vanilla-mode-enable)))
     ("i" .  (weiss-dired-find-up-dir (find-alternate-file "..")))
     ("j" .  dired-next-line)
     ("k" .  dired-previous-line)
     ("l" .  dired-find-file)
     ("m" .  dired-mark)
     ("o" .  xah-open-in-external-app)
     ("p" .  peep-dired)
     ("q" .  quit-window)
     ("r" .  dired-do-rename)
     ("t" .  dired-toggle-marks)
     ("u" .  dired-unmark)
     ("v" .  weiss-dired-git-clone)
     ("x" .  dired-do-flagged-delete)
     ("y v" .  weiss-dired-merge-videos)
     ("z" .  dired-do-compress)
     ("RET" . dired-find-file))
   )
  )

;; parent: 
(provide 'weiss_dired_keybindings)
