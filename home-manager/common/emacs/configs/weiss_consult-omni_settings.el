(setq 
 consult-async-min-input 0
 consult-omni-sources-modules-to-load '()
 consult-omni-show-preview t    
 consult-omni-default-interactive-command #'consult-omni-multi
 consult-omni-dynamic-input-debounce 0.3
 consult-omni-dynamic-input-throttle consult-omni-dynamic-input-debounce
 ;; consult-async-split-style 'comma 
 consult-async-split-style 'perl
 )

(defun weiss-consult-omni-multi (&optional initial prompt sources no-callback min-input valid-input &rest args)
  "change sort to nil"
  (interactive "P")
  (let* ((consult-async-refresh-delay consult-omni-dynamic-refresh-delay)
         (consult-async-input-throttle consult-omni-dynamic-input-throttle)
         (consult-async-input-debounce consult-omni-dynamic-input-debounce)
         (weiss-consult-omni-current-buffer (current-buffer))
         (sources (or sources consult-omni-multi-sources))
         (sources (remove nil (mapcar (lambda (source)
                                        (cond
                                         ((stringp source)
                                          (consult-omni--get-source-prop source :source))
                                         ((symbolp source)
                                          source)))
                                      sources)))
         (prompt (or prompt (concat "[" (propertize "consult-omni-multi" 'face 'consult-omni-prompt-face) "]" " Search:  ")))
         (selected 
          (consult-omni--multi-dynamic
           sources
           min-input
           args
           :prompt prompt
           :sort nil
           :require-match nil
           :history '(:input consult-omni--search-history)
           :add-history (consult-omni--add-history '(symbol))
           :initial initial))
         (match (plist-get (cdr selected) :match))
         (source  (plist-get (cdr selected) :name))
         (selected (cond
                    ((consp selected) (car-safe selected))
                    (t selected)))
         (selected (if match selected (string-trim selected (consult-omni--get-split-style-character))))
         (callback-func (and (not no-callback)
                             (or (and match source (consult-omni--get-source-prop source :on-callback))
                                 #'consult-omni--default-new))))
    (unless consult-omni-log-level
      (consult-omni--kill-hidden-buffers)
      (consult-omni--kill-url-dead-buffers))
    (cond
     ((and match (functionp callback-func))
      (funcall callback-func selected))
     ((functionp callback-func)
      (setq selected (funcall callback-func selected))))
    selected))

(advice-add 'consult-omni-multi :override #'weiss-consult-omni-multi)

(defun consult-omni--choose-new (cand &rest args)
  "Create new item based on chosen source"
  (interactive)
  (let* ((sources 
          (cl-remove-duplicates 
           (delq nil (mapcar (lambda (item)
                               (when-let ((new (consult-omni--get-source-prop item :on-new))
                                          (name (consult-omni--get-source-prop item :name)))
                                 (when (not (eq new #'consult-omni--default-new)) 
                                   (cons name new)))) 
                             consult-omni-multi-sources))))
         (action (consult--read sources
                                :prompt "Create a new item on source: "
                                :lookup #'consult--lookup-cdr
                                )))
    (if (functionp action) 
        (funcall action cand)
      (error "Do not know how to make a new item for that source!"))))

(with-eval-after-load 'consult-omni  
  (require 'consult-omni-sources)
  ;; (consult-omni-sources-load-modules)
  (setq consult-omni-default-new-function #'consult-omni--choose-new)
  )

(provide 'weiss_consult-omni_settings)
