(setq default-input-method "rime")
(with-eval-after-load 'rime
  (setq
   rime-show-candidate 'minibuffer
   rime-translate-keybindings  '("C-f" "C-b" "C-n" "C-p" "C-g" "`" ";" "<dead-grave>")
   rime-inline-ascii-trigger 'control-r
   )

  (defun weiss-rime-return ()
    "DOCSTRING"
    (interactive)
    (if (and (enter-rime--should-inline-ascii-p)
             (not (rime--ascii-mode-p))
             )
        (rime-inline-ascii)
      (rime--return)
      )
    )

  ;; (setq rime-emacs-module-header-root "/opt/homebrew/include/")
  ;; (setq rime-share-data-dir "/Users/bozhoubai/Library/Rime/")  

  )

;; (add-to-list 'load-path "/Users/bozhoubai/.emacs.d/emacs-rime/")
(require 'rime)


;; parent: 
(provide 'weiss_rime_settings)
