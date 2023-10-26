(with-eval-after-load 'mind-wave
  (defun weiss-new-chat-file ()
    "DOCSTRING"
    (interactive)
    (let ((prefix "chat-")
          (date (format-time-string "%S-[%H-%M]-{%0d.%m.%Y}"))
          (dir "~/Documents/chats/")
          (ext ".chat"))
      (make-directory dir t)
      (find-file (concat dir prefix date ext))))
  
  (defun weiss-mind-wave-correct-grammatical-mistakes ()
    (interactive)
    (message "Checking...")
    (mind-wave-call-async "action_code"
                          (buffer-name)
                          "text-mode"
                          (mind-wave--encode-string (nth 2 (mind-wave-get-region-or-buffer)))
                          mind-wave-summary-role
                          "Please check for any English or German grammatical mistakes or typos in the following paragraph and list mistakes one by one, where each item contains the reason and corrected text (You should not repeat the original text):" 
                          (concat "grammatical-mistakes" (format-time-string "%S-[%H-%M]-{%0d.%m.%Y}"))
                          "ChatGPT checking..."
                          "ChatGPT check finish."))

  (defun weiss-mind-wave-rephrase ()
    (interactive)
    (message "rephrasing...")
    (mind-wave-call-async "action_code"
                          (buffer-name)
                          "text-mode"
                          (mind-wave--encode-string (nth 2 (mind-wave-get-region-or-buffer)))
                          mind-wave-summary-role
                          "Please rephrase the following paragraph:" 
                          (concat "rephrase" (format-time-string "%S-[%H-%M]-{%0d.%m.%Y}"))
                          "ChatGPT rephrasing..."
                          "ChatGPT finished rephrasing."))

  (defun weiss-mind-wave-pdf-to-text ()
    (interactive)
    (message "converting...")
    (mind-wave-call-async "action_code"
                          (buffer-name)
                          "text-mode"
                          (mind-wave--encode-string (weiss-extract-text-from-current-pdf-page))
                          mind-wave-summary-role
                          "Please make the following paragraphs have correct line breaks (which means you should concat lines together if it should be), a proper unicode display, such that x1 should be x₁, xi should be xᵢ, and so on:" 
                          (format "pdf-to-text-[%s]-[%s]" (buffer-name) (pdf-view-restore-get-page))
                          "ChatGPT converting..."
                          "ChatGPT finished converting."))
  )

(provide 'weiss_mind-wave_settings)


