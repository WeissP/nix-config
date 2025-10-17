(with-eval-after-load 'gptel
  (setq 
   gptel-track-media t 
   gptel-default-mode 'org-mode   
   )

  (setq gptel-model 'gpt-5)
  ;; (put 'o4-mini :request-params '(:reasoning_effort "high" :stream :json-false))
  (when (fboundp 'password-store-get-field)
    (require 'password-store)
    (setq gptel-api-key (password-store-get-field "openai" "api"))
    (gptel-make-anthropic "Claude"
      :stream t                             
      :key (password-store-get-field "anthropic" "api-key"))
    (gptel-make-gemini "Gemini"
      :stream t
      :key (password-store-get-field "gemini" "api-key")
      )
    (gptel-make-openai "DeepSeek"       ;Any name you want
      :host "api.deepseek.com"
      :endpoint "/chat/completions"
      :stream t
      :key (password-store-get-field "deepseek" "api-key")
      :models '(deepseek-chat deepseek-coder deepseek-reasoner))
    (gptel-make-openai "OpenRouter"
      :host "openrouter.ai"
      :endpoint "/api/v1/chat/completions"
      :stream t
      :key (password-store-get-field "openrouter" "api-key")
      :models '(google/gemini-2.5-pro-preview-03-25
                ))

    )
  )

(provide 'weiss_gptel_settings)




