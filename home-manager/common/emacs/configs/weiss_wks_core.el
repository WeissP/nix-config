(setq wks-init-emulation-order 2)       ; the first one is for company-mode-map

(defmacro wks-create-function (name functions)
  `(defun ,name ()
     "auto generated by wks-create-function"
     (interactive)
     (dolist (x ',functions) (eval x))
     )
  )

(defun wks-define-key (keymap prefix key-cmd-alist)
  "DOCSTRING"
  (interactive)
  (mapc
   (lambda (pair)
     (if (listp (cdr pair))
         (let ((name (cadr pair))
               (functions (cddr pair))
               )
           (eval `(wks-create-function ,name ,functions))             
           (define-key keymap (kbd (concat prefix (car pair))) name)
           )
       (define-key keymap (kbd (concat prefix (car pair))) (cdr pair))
       )
     )
   key-cmd-alist)
  )

(defun wks-unset-key (map keys &optional number alphabet)
  "DOCSTRING"
  (interactive)
  (mapc (lambda (x) (define-key map (kbd x) nil)) keys)
  (when number
    (mapc (lambda (x) (define-key map (kbd x) nil))
          (mapcar 'number-to-string (number-sequence 0 9))))
  (when alphabet
    (mapc (lambda (x) (define-key map (kbd x) nil))
          (mapcar (lambda (x) (format "%c" x)) (append (number-sequence 65 90)
                                                       (number-sequence 97 122)))))
  )

(defun wks-trans-keys (keys)
  "DOCSTRING"
  (interactive)
  (mapc
   (lambda (pair)
     (define-key key-translation-map (kbd (car pair)) (kbd (cdr pair)))
     )
   keys)
  )

(defun wks-define-vanilla-keymap ()
  "DOCSTRING"
  (interactive)
  (let ((key-list
         (append
          '("SPC")
          (mapcar (lambda (x) (format "%c" x)) (number-sequence 33 126))))
        (keymap (make-sparse-keymap))
        )
    (dolist (x key-list keymap) 
      (define-key keymap (kbd x) #'self-insert-command)
      )
    )
  )
(setq wks-vanilla-keymap (wks-define-vanilla-keymap))

(defun wks-conditional-define-key (keymap key-cmd-list fun)
  (interactive)
  (mapc
   (lambda (cmd-key)
     (let ((key (car cmd-key))
           (cmd (cdr cmd-key))
           )
       (define-key keymap (kbd key)
                   `(menu-item "" ,cmd
                               :filter ,fun)
                   )
       )
     )
   key-cmd-list)
  )

(wks-unset-key help-mode-map '("SPC" "-" "l") t)
(wks-unset-key messages-buffer-mode-map '("SPC" "9" "-" "0"))
(wks-unset-key special-mode-map '("SPC" "9" "-" "0"))

(provide 'weiss_wks_core)
