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
  )

(provide 'weiss_mind-wave_settings)
