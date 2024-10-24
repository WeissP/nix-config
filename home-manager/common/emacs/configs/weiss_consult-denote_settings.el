(require 'consult-denote)
(with-eval-after-load 'consult-denote
  (add-to-list 'consult-buffer-sources #'consult-denote-buffer-source t)  
  )

;; (let ((dir (denote-directory)))
;;   (pcase-let* ((`(,prompt ,paths ,dir) (consult--directory-prompt "Find" dir))
;;                (default-directory dir)
;;                (builder (consult--find-make-builder paths)))
;;     (consult--find prompt builder nil)))


(provide 'weiss_consult-denote_settings)
