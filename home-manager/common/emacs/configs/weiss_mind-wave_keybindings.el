(with-eval-after-load 'mind-wave
  (wks-unset-key mind-wave-chat-mode-map '("`"))

  (wks-define-key
   (current-global-map)
   "SPC "
   '(("d c" .  weiss-new-chat-file)
     ))

  (wks-define-key
   mind-wave-chat-mode-map
   ""
   '(
     ("C-c '" . mind-wave-chat-ask)
     ("C-c C-c" . mind-wave-chat-ask-send-buffer)
     ("C-c C-," . mind-wave-chat-ask-insert-line)
     ))
  )

(provide 'weiss_mind-wave_keybindings)
