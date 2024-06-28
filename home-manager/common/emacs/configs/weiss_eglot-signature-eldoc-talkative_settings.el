(with-eval-after-load 'eglot
  (require 'eglot-signature-eldoc-talkative)
  (advice-add #'eglot-signature-eldoc-function
              :override #'eglot-signature-eldoc-talkative)
  )

(provide 'weiss_eglot-signature-eldoc-talkative_settings)
