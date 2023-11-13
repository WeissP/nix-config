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
                          "Please rephrase the following paragraph to make it more fluently:" 
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
                          "1. Ensure that the paragraphs I gave you later have proper unicode display, such that x1 should be displayed as x₁, xi as xᵢ, xk as xₖ, and so on.
2. Replace common expressions with logic operations:
   - Expressions that mean 'there is a xxx' should be replaced with ∃ xxx.
   - Expressions that mean 'for all xxx' should be replaced with ∀ xxx.
3. Maintain correct line breaks by concatenating lines/symbols together when necessary.

The paragraphs:
" 
                          (format "pdf-to-text-[%s]-[%s]" (buffer-name) (pdf-view-restore-get-page))
                          "ChatGPT converting..."
                          "ChatGPT finished converting."))

  (setq mind-wave-chat-model "gpt-3.5-turbo")

  (defun weiss-mind-wave-show-chat-window (buffername mode)
    "split window dwim"
    (setq mind-wave-window-configuration-before-split (current-window-configuration))
    (delete-other-windows)
    (weiss-split-window-dwim)
    (other-window 1)
    (get-buffer-create buffername)
    (switch-to-buffer buffername)
    (funcall (intern mode))
    (read-only-mode -1))
  (advice-add 'mind-wave-show-chat-window :override #'weiss-mind-wave-show-chat-window)
  )

(provide 'weiss_mind-wave_settings)


