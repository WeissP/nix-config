(with-eval-after-load 'org
  (setq
   org-agenda-files '("~/Documents/notes/misc/notes/20240428T091509--time-tracking.org")
   org-agenda-todo-ignore-scheduled t
   org-agenda-prefix-format "%t %s " ;hide files name
   org-agenda-skip-scheduled-if-done t
   org-agenda-include-diary t
   org-agenda-window-setup 'current-window
   org-agenda-custom-commands
   '(
     ("c" "Custom agenda"
      ((agenda ""))
      (
       ;; (org-agenda-tag-filter-preset '("+dailyagenda"))
       (org-agenda-hide-tags-regexp (concat org-agenda-hide-tags-regexp "\\|dailyagenda"))
       (org-agenda-span 20)))
     ("b" occur-tree "Bookmarks"))
   org-agenda-compact-blocks t
   )

  (defun weiss-custom-daily-agenda()
    (interactive)
    (org-agenda nil "c"))
  ;; (getenv "PATH")
  )

(provide 'weiss_org_agenda)
