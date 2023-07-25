(with-eval-after-load 'ess-r-mode
  (wks-unset-key ess-r-mode-map '(","))  
  (wks-unset-key ess-r-help-mode-map '("a" "k" "l" "i"))  
  )

(provide 'weiss_ess_keybindings)
