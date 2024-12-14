(with-eval-after-load 'chatgpt-shell 
  (when (fboundp 'password-store-get-field)
    (require 'password-store)
    (setq chatgpt-shell-openai-key (password-store-get-field "openai" "api"))
    )
  (require 'ob-chatgpt-shell)
  (ob-chatgpt-shell-setup)
;;   (ob-chatgpt-shell--make-assistant :name "PDF Assistant"  :instructions "You’re an intelligent PDF document assistant with the ability to analyze and extract information from various types of PDF files. You have a deep understanding of content structure, context, and can provide accurate answers to questions based on the content of the PDF file. 
;; Your task is to answer questions regarding a specific PDF document. Please analyze the information provided in the PDF and respond accurately to the inquiries.
;; Please ensure that your responses are clear, concise, and directly relevant to the questions asked.")

  ;; assistant-id: asst_JszPZ7I3AZMZF4FVERvrBeOf

  )

(provide 'weiss_chatgpt-shell_settings)
