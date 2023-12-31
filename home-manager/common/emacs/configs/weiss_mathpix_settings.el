(defun mathpix-screenshot ()
  "screenshot a image, return the path of the image"
  (interactive)
  (shell-command-to-string "flameshot gui -p /tmp/")
  "/tmp/flameshot-capture.png")

(defun mathpix-get-b64-image (file)
  "From mathpix.el.
          Return the base-64 image string from FILE."
  (with-temp-buffer
    (insert-file-contents file)
    (base64-encode-string (buffer-string) t)))

(defun mathpix-insert-result (file)
  "Sends FILE to Mathpix API."
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
             ("formats" . ,(list "latex_styled"))
             ("format_options" .
              ,`(("math_delims" . '("\\(" "\\)"))
                 ("displaymath_delims" . '("\\[" "\\]"))))))
    :parser 'json-read
    :sync t
    :complete (cl-function
               (lambda (&key response &allow-other-keys)
                 (->>
                  response
                  (request-response-data)
                  (alist-get 'latex_styled)
                  ;; preventing org rendering org-emphasis
                  (s-replace "*" " * ") 
                  (s-replace "=" " = ") 
                  (s-replace "^{\\top}" "^{T}") ; Transpose but not \top
                  ((lambda (text)
                     (if (s-contains? "\n" text)
                         (insert text)
                       (insert (format "\\[%s\\]" text))
                       )))
                  )))))


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
      (t (ignore))    
      )
    )
  )

(provide 'weiss_mathpix_settings)
