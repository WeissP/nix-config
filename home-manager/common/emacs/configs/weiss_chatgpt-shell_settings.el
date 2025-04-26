(with-eval-after-load 'chatgpt-shell 
  (when (fboundp 'password-store-get-field)
    (require 'password-store)
    (setq chatgpt-shell-openai-key (password-store-get-field "openai" "api"))
    )
  (require 'ob-chatgpt-shell)
  (ob-chatgpt-shell-setup)
    ;; (ob-chatgpt-shell--make-assistant :name "PDF Assistant"  :instructions "You’re an intelligent PDF document assistant with the ability to analyze and extract information from various types of PDF files. You have a deep understanding of content structure, context, and can provide accurate answers to questions based on the content of the PDF file. 
  ;; ;; Your task is to answer questions regarding a specific PDF document. Please analyze the information provided in the PDF and respond accurately to the inquiries.
  ;; ;; Please ensure that your responses are clear, concise, and directly relevant to the questions asked.")
  ;; assistant-id: asst_JszPZ7I3AZMZF4FVERvrBeOf
  
;; (ob-chatgpt-shell--make-assistant :name "Editor Assistant"  :instructions "You are an experienced academic editor specializing in computer science papers with over 10 years of experience. You have a keen eye for detail and an understanding of the intricacies of academic writing, ensuring clarity, coherence, and adherence to formatting standards.

;; Your task is to edit a draft of an academic paper. Here is the draft text that needs editing: ")
;; asst_Pv1V6AZKcDtfgLtUNd5qppz2


  ;; A quick fix of header bug
  (cl-defun ob-chatgpt-shell--upload-file (&key purpose path)
    "Upload file at PATH and describe PURPOSE."
    (unless purpose
      (error "Missing mandatory :purpose param"))
    (unless path
      (error "Missing mandatory :path param"))
    (unless (file-exists-p path)
      (error "Path does not exist: %s" path))
    (unless (file-regular-p path)
      (error "Path is not a file: %s" path))
    (when-let ((result
                (shell-maker-make-http-request
                 :async nil
                 :url "https://api.openai.com/v1/files"
                 :headers (list (format "Authorization: Bearer %s" (chatgpt-shell-openai-key)))
                 :fields `(,(format "purpose=%s" purpose)
                           ,(format "file=@%s" path))
                 :filter (lambda (raw-response)
                           (if-let* ((parsed (shell-maker--json-parse-string raw-response))
                                     (response (or (let-alist parsed
                                                     .error.message)
                                                   (let-alist parsed
                                                     .id))))
                               response
                             (error "Couldn't parse %s" raw-response)))))
               (success (map-elt result :success)))
      (map-elt result :output)))

  )


(provide 'weiss_chatgpt-shell_settings)
