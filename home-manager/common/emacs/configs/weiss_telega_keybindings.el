(with-eval-after-load 'telega
  
  (wks-define-key
   telega-msg-button-map ""
   '(("-" . push-button)
     ;; ("c" . weiss-telega-copy-msg)
     ;; ("SPC" . wks-leader-keymap)
     ("C-r" . telega-chatbuf-filter-search))
   )

  (wks-define-key
   telega-chat-mode-map ""
   '(("C-r" . telega-chatbuf-filter-search)))


  (wks-unset-key telega-root-mode-map '("s" "i" "a"))
  (wks-unset-key telega-chat-button-map '("s" "i" "a"))
  (wks-unset-key telega-msg-button-map '("k" "l" "i" "=" "a" "SPC" "f" "^"))
  (wks-unset-key telega-webpage-mode-map
                 '("h" "k" "l" "i" "=" "a""c")))

(provide 'weiss_telega_keybindings)
