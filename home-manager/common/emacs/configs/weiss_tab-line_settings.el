(setq tab-line-switch-cycling t)

;; (name . group)
(defconst weiss-tab-groups-file "~/.emacs.d/tab-groups.el")
(defvar weiss-tab-groups nil)
(defvar weiss-file-groups nil)

;; (frame . name)
(defvar weiss-tab-group-name-per-frame nil)

(defun weiss-load-file-groups ()
  "DOCSTRING"
  (interactive)
  (ignore-errors (load weiss-tab-groups-file)))

(defun weiss-tab-bind-group (group-name)
  "DOCSTRING"
  (interactive "sGroup Name: ")
  ;; (message "group-name: %s" group-name)
  (message "group-name: %s" group-name)
  (let ((elem `(,(selected-frame) . ,group-name))
        )
    (weiss-tab-unbind-group)
    (if weiss-tab-group-name-per-frame
        (add-to-list 'weiss-tab-group-name-per-frame elem)
      (push elem weiss-tab-group-name-per-frame))
    (unless (plist-member weiss-tab-groups (intern group-name))
      (setq weiss-tab-groups
            (plist-put weiss-tab-groups (intern group-name) nil)))))

(defun weiss-tab-get-current-group-name ()
  "DOCSTRING"
  (interactive)
  (cdr (assoc (selected-frame) weiss-tab-group-name-per-frame)))

(defun weiss-tab-unbind-group ()
  "DOCSTRING"
  (interactive)
  ;; (message "unbind: %s" (selected-frame))
  (assq-delete-all (selected-frame) weiss-tab-group-name-per-frame)
  )

(defun weiss-tab-to-file-groups (tab-groups)
  "DOCSTRING"
  (interactive)
  (-map-indexed
   (lambda (idx elem)
     (if (eq (% idx 2) 0)
         elem
       (when elem
         (mapcar (lambda (x) (buffer-file-name x)) elem))))
   tab-groups))

(defun weiss-load-file-group-to-tab (key)
  "DOCSTRING"
  (interactive)
  (thread-last key
               (intern)
               (plist-get weiss-file-groups )
               (mapcar 'find-file-noselect)
               (plist-put weiss-tab-groups (intern key))
               (setq weiss-tab-groups)))

(defun weiss-load-tab-group (key)
  "DOCSTRING"
  (interactive)
  (weiss-load-file-group-to-tab key)
  (weiss-tab-bind-group key))

(defun weiss-file-groups-to-file (file-groups)
  "DOCSTRING"
  (interactive)
  (write-region
   (format
    "\n(setq weiss-file-groups '%s)"
    (-map-indexed
     (lambda (idx elem)
       (if (eq (% idx 2) 0)
           (format "\n  %s" elem)
         (if elem
             (format
              "(%s)"
              (mapconcat (lambda (x) (format "\n      \"%s\"" x)) elem " "))
           "nil")))
     file-groups))
   nil weiss-tab-groups-file))

(defun weiss-file-groups-delete-reg (reg)
  "DOCSTRING"
  (interactive)
  (weiss-load-file-groups)
  (let* ((key-indices (--find-indices (and (symbolp it) (string-match reg (symbol-name it))) weiss-file-groups))
         (indices (append key-indices (-map #'1+ key-indices)))
         )    
    (setq weiss-file-groups (-remove-at-indices indices weiss-file-groups))
    (weiss-file-groups-to-file weiss-file-groups)
    )
  )

(defun weiss-file-groups-delete (name)
  "DOCSTRING"
  (interactive)
  (weiss-file-groups-delete-reg (regexp-quote name))
  )

(defun weiss-dump-tab-groups ()
  "DOCSTRING"
  (interactive)
  (weiss-load-file-groups)
  (->
   weiss-tab-groups
   (weiss-tab-to-file-groups )
   (weiss-plist-merge  weiss-file-groups)
   (weiss-file-groups-to-file))
  (weiss-load-file-groups))

(defun weiss-add-buffer-to-tab-group ()
  "DOCSTRING"
  (interactive)
  (if-let ((group-name (weiss-tab-get-current-group-name))
           )
      (let* ((name-symbol (intern group-name))
             (b (current-buffer))
             (g (plist-get weiss-tab-groups name-symbol)))
        (setq weiss-tab-groups
              (plist-put weiss-tab-groups name-symbol
                         (add-to-list 'g b))))
    (message "Please first bind current frame to a group!")))

(defun weiss-tab-remove-current-buffer ()
  "DOCSTRING"
  (interactive)
  (let ((n (intern (weiss-tab-get-current-group-name)))
        (g (weiss-tab-get-current-group)))
    (setq
     weiss-tab-groups
     (plist-put weiss-tab-groups n
                (seq-filter
                 (lambda (x)
                   (and
                    (buffer-live-p x)
                    (not (eq (current-buffer) x))))
                 g)))))

(defun weiss-tab-remove-killed-buffer ()
  "DOCSTRING"
  (interactive)
  (setq weiss-tab-groups
        (mapcar
         (lambda (e)
           (if (listp e)
               (seq-filter
                (lambda (x)
                  (and
                   (buffer-live-p x)
                   (not (eq (current-buffer) x))))
                e)
             e))
         weiss-tab-groups)))

(add-hook 'kill-buffer-hook #'weiss-tab-remove-killed-buffer)

(defun weiss-tab-next ()
  "DOCSTRING"
  (interactive)
  (if-let ((g (weiss-tab-get-current-group)))
      (if (member (current-buffer) g)
          (tab-line-switch-to-next-tab)    
        (switch-to-buffer (car g))
        )  
    (tab-line-switch-to-next-tab)
    )
  )

(defun weiss-tab-prev ()
  "DOCSTRING"
  (interactive)
  (if-let ((g (weiss-tab-get-current-group)))
      (if (member (current-buffer) g)
          (tab-line-switch-to-prev-tab)    
        (switch-to-buffer (car (last g)))
        )  
    (tab-line-switch-to-prev-tab)
    )
  )

(defun weiss-tab-get-current-group ()
  "DOCSTRING"
  (interactive)
  (when-let ((name (weiss-tab-get-current-group-name)))
    (plist-get weiss-tab-groups (intern name))))

(defun weiss-tab-all-group-names ()
  "DOCSTRING"
  (interactive)
  (mapcar 'symbol-name
          (seq-filter
           (lambda (x) (not (listp x)))
           (append weiss-tab-groups weiss-file-groups))))

(defun weiss-tab-group-or-buffer ()
  "DOCSTRING"
  (interactive)
  (or (weiss-tab-get-current-group)
      (tab-line-tabs-mode-buffers)
      ;; (tab-line-tabs-window-buffers)
      ))

(defun weiss-tab-line-tabs-function ()
  "DOCSTRING"
  (interactive)
  (if-let ((r (weiss-tab-get-current-group)))
      r
    '("no group")))

(with-eval-after-load 'tab-line
  (weiss-load-file-groups)
  (setq tab-line-tabs-function 'weiss-tab-group-or-buffer)
  (global-tab-line-mode)
  )


;; parent: 
(provide 'weiss_tab-line_settings)
