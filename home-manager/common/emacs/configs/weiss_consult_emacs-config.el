(defun weiss-all-config-file-short-names ()
  "DOCSTRING"
  (interactive)
  (-map (lambda (s) (s-chop-left 6 s)) 
        (directory-files weiss/configs-dir nil "weiss\_.*el")))
 
(defun weiss-find-emacs-config-short (name)
  "DOCSTRING"
  (interactive)
  (find-file (f-join weiss/configs-dir (concat "weiss_" name)))
  )

(defun weiss-new-emacs-config-file (s)
  "DOCSTRING"
  (interactive)
  (-let [(pkg module full) (weiss-complete-emacs-config-module-names s)]
    (setq full (format "weiss_%s_%s" pkg module))
    (find-file
     (concat weiss/configs-dir full ".el"))
    (insert
     (format "(with-eval-after-load '%s\n\n)\n\n(provide '%s)" pkg full))
    (goto-char (point-min))))

(defun weiss-complete-emacs-config-module-names (s)
  "DOCSTRING"
  (interactive)
  (-let
      [((pkg module)
        alist
        res class parent)
       (list
        (split-string s " ")
        '(("a" . "abbrevs")
          ("sn" . "snails")
          ("ltx" . "latex")
          ("e" . "edit")
          ("l" . "lsp-mode")
          ("jpt" . "jupyter")
          ("sh" . "shell-and-terminal")
          ("f" . "font-lock-face")
          ("fc" . "flycheck")
          ("fs" . "flyspell")
          ("d" . "dired")
          ("tr" . "translation")
          ("ro" . "org-roam")
          ("sp" . "weiss-org-sp-mode")
          ("s" . "settings")
          ("k" . "keybindings")
          ("m" . "misc")
          ("w" . "wks")
          ("q" . "quick-insert")))
       ]
    (list (or (cdr (assoc pkg alist)) pkg) (or (cdr (assoc module alist)) module))))

(with-eval-after-load 'weiss_consult_settings
  (setq weiss-consult-source-emacs-config
        (list 
         :name     "emacs-config"
         :category 'emacs-config
         :narrow   ?e
         :action #'weiss-find-emacs-config-short
         :face     'consult-file
         :new #'weiss-new-emacs-config-file 
         :require-match nil
         :items #'weiss-all-config-file-short-names
         :state (weiss-consult-file-state-under-dir weiss/configs-dir (lambda (cand) (concat "weiss_" cand)))
         ))
  (add-to-list 'consult-buffer-sources #'weiss-consult-source-emacs-config t)
  )

(provide 'weiss_consult_emacs-config)
