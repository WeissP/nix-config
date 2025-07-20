(with-eval-after-load 'gptel
  (require 'gptel-prompts)  
  (setq gptel-directives nil)
  (gptel-prompts-update)
  )

(provide 'weiss_gptel-prompts_settings)

