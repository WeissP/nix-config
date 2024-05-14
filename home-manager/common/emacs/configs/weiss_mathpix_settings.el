(defun mathpix-screenshot ()
  "screenshot a image, return the path of the image"
  (interactive)
  (let ((path "/tmp/flameshot-capture.png"))
    (delete-file path)
    (shell-command-to-string "flameshot gui -p /tmp/")
    path 
    )
  )

(defun mathpix-get-b64-image (file)
  "From mathpix.el.
          Return the base-64 image string from FILE."
  (with-temp-buffer
    (insert-file-contents file)
    (base64-encode-string (buffer-string) t)))

(defun mathpix-insert-result (file)
  "Sends FILE to Mathpix API."
  (let ((line-empty-p (weiss-line-empty-p))
        )    
    (request
      "https://api.mathpix.com/v3/text"
      :type "POST"
      :headers `(("app_id" . ,mathpix-api-id)
                 ("app_key" . ,mathpix-api-key)
                 ("Content-type" . "application/json"))
      :data (json-encode-alist
             `(("src" . ,(format "data:image/%s;base64,%s"
                                 (file-name-extension file)
                                 (mathpix-get-b64-image file)))
               ("idiomatic_eqn_arrays" . true)
               ("idiomatic_braces" . true)
               ("formats" . ("text"))
               ("format_options" .
                ,`(("math_delims" . '("\\(" "\\)"))
                   ("displaymath_delims" . '("\\[" "\\]"))))))
      :parser 'json-read
      :sync t
      :complete (cl-function
                 (lambda (&key response &allow-other-keys)
                   (-some->>
                       response
                     (request-response-data)
                     ((lambda (data) (message "data: %s" data) data))
                     (alist-get 'text)
                     ;; preventing org rendering org-emphasis
                     (s-replace "*" " * ") 
                     (s-replace "+" " + ") 
                     (s-replace "~" " ~ ") 
                     (s-replace "-" " - ") 
                     (s-replace "=" " = ") 
                     (s-replace "^{\\top}" "^{T}") ; Transpose but not \top
                     (insert)
                     ))))
    ))


(defun mathpix-insert ()
  "DOCSTRING"
  (interactive)
  (let* ((img-path (mathpix-screenshot)))
    (while (not (file-exists-p img-path)) (sit-for 0.1))      
    (mathpix-insert-result img-path)
    (delete-file img-path)
    ))

(with-eval-after-load 'org
  (defun mathpix-insert-and-preview ()
    "DOCSTRING"
    (interactive)
    (mathpix-insert)
    (pcase major-mode
      ('org-mode (call-interactively 'org-latex-preview))
      (_ (ignore))    
      )
    )
  )

(provide 'weiss_mathpix_settings)
