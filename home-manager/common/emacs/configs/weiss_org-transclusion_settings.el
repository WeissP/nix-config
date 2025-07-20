(add-hook 'org-mode-hook #'org-transclusion-mode)

(defun weiss-insert-org-transclusion ()
  "DOCSTRING"
  (interactive)
  (call-interactively 'org-insert-link)
  (insert " :only-contents")
  (beginning-of-line)
  (insert "#+transclude: ")
  (call-interactively 'org-transclusion-add)
  )

(with-eval-after-load 'org-transclusion
  (add-to-list 'org-transclusion-extensions 'org-transclusion-indent-mode)
  (require 'org-transclusion-indent-mode)

  (set-face-attribute
   'org-transclusion-fringe nil
   :background "#c0e7d4" :foreground "#c0e7d4")
  (set-face-attribute
   'org-transclusion-source-fringe nil
   :background "#efe9dd" :foreground "#efe9dd")
  )



(provide 'weiss_org-transclusion_settings)
