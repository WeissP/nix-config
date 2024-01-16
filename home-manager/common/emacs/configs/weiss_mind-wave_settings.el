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
  
  (setq mind-wave-async-text-model "gpt-4")
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

  (defun weiss-mind-wave-align-latex ()
    (interactive)
    (message "aligning...")
    (mind-wave-call-async "action_code"
                          (buffer-name)
                          "text-mode"
                          (mind-wave--encode-string (nth 2 (mind-wave-get-region-or-buffer)))
                          mind-wave-summary-role
                          "Please make the following latex code into align environment:" 
                          (concat "align" (format-time-string "%S-[%H-%M]-{%0d.%m.%Y}"))
                          "ChatGPT aligning..."
                          "ChatGPT finished aligning."))

  (defun weiss-mind-wave-pdf-to-text ()
    (interactive)
    (message "converting...")
    (mind-wave-call-async "action_code"
                          (buffer-name)
                          "text-mode"
                          (mind-wave--encode-string (weiss-extract-text-from-current-pdf-page))
                          mind-wave-summary-role
                          "Process the following paragraphs in three steps and only output the final result. Be sure to follow these guidelines:

1. Ensure that the paragraphs have proper unicode display, such that x₁ should be displayed as x₁, xi as xᵢ, xk as xₖ, xn as xₙ, Nd as Nᵈ, and so on.
2. Make item lists (if they exist) more consistent:
   - For unordered lists (such as lists starting with ▶), use only a hyphen (-) as the item symbol.
   - For ordered lists, use 1., 2., 3. as the item symbols.
   - If there are nested lists, use four spaces as indentation.
3. Maintain correct line breaks by concatenating lines/symbols together when necessary.

The paragraphs:
" 
                          (format "pdf-to-text-[%s]-[%s]" (buffer-name) (pdf-view-current-page))
                          "ChatGPT converting..."
                          "ChatGPT finished converting."))

  (setq mind-wave-chat-model "gpt-4")

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


