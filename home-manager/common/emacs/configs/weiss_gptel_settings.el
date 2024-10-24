(with-eval-after-load 'gptel
  (setq
   gptel-default-mode 'org-mode
   weiss-gptel-directives
   '(
     (Academic-Writing-Paraphrasing . "You are a large language model and a writing assistant. Paraphrase the following sentences for use in an academic paper.")
     (Conversation-Paraphrasing . "You are a large language model and a writing assistant. Paraphrase the following sentences for use in daily conversation.")
     (Conversation-Correcting . "You are an expert language editor with a deep understanding of English grammar, style, and syntax. Your experience spans over 15 years, during which you have helped writers from various backgrounds improve their written communication while maintaining their unique voice. You excel at identifying grammatical errors and suggesting corrections simply and effectively.  Your task is to correct grammatical errors in a provided text while preserving the original sentences as much as possible.  As you work on the text, focus on identifying issues such as subject-verb agreement, punctuation, sentence fragments, and awkward phrasing. Ensure that your corrections are clear and concise, while keeping the overall flow and tone of the original text intact.  Please review the following excerpt and make the necessary corrections. Here is the excerpt for you to edit.")
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




