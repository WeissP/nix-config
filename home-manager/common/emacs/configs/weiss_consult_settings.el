;; -*- lexical-binding: t -*-

(defun weiss-consult-file-state-under-dir (dir &optional get-full-name)
  "DOCSTRING"
  (interactive)
  (lambda ()
    (let ((open (consult--temporary-files))
          (state (consult--file-state))
          )
      (lambda (action cand)
        (unless cand
          (funcall open))
        (funcall state action
                 (and cand
                      (expand-file-name
                       (if get-full-name (funcall get-full-name cand) cand) dir)))))))

(defun consult-ripgrep-all (&optional dir initial)
  "copied from https://gist.github.com/jthaman/c4eb411defc98f82cfd85c8c0d4c67e0"
  (interactive "P")
  (let ((consult-ripgrep-args "rga --null --line-buffered --color=never --max-columns=1000  --smart-case --no-heading --with-filename --line-number"))
    (consult-ripgrep dir initial)))

(defvar weiss-consult--source-buffer
  `(:name     "Buffer"
              :narrow   ?b
              :category buffer
              :face     consult-buffer
              :history  buffer-name-history
              :state    ,#'consult--buffer-state
              :default  t
              :items
              ,(lambda () (consult--buffer-query :sort 'alpha
                                                 :filter 'nil
                                                 :as #'consult--buffer-pair)))
  "Buffer candidate source for `consult-buffer'.")

(with-eval-after-load 'consult
  (setq consult-buffer-sources
        (remove 'consult--source-bookmark consult-buffer-sources))
  )

(provide 'weiss_consult_settings)
