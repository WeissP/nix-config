(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(setq markdown-hide-markup-in-view-modes nil)

(setq markdown-command "pandoc")

;; parent: 
(provide 'weiss_markdown-mode_settings)
