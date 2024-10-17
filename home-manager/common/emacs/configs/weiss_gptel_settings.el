(with-eval-after-load 'gptel
  (setq
   gptel-default-mode 'org-mode
   weiss-gptel-directives
   '(
     (Academic-Writing-Paraphrasing . "You are a large language model and a writing assistant. Paraphrase the following sentences for use in an academic paper.")
     (Conversation-Paraphrasing . "You are a large language model and a writing assistant. Paraphrase the following sentences for use in daily conversation.")
     (document-code-Paraphrasing . "You are a large language model, a writing assistant and a careful programmer. Paraphrase the following documentation comment.")
     )
   )

  (setq gptel-directives (-concat gptel-directives weiss-gptel-directives)
        gptel-model "gpt-4o-mini")

  (when (fboundp 'password-store-get-field)
    (require 'password-store)
    (setq gptel-api-key (password-store-get-field "openai" "api"))
    )
  )

(provide 'weiss_gptel_settings)
