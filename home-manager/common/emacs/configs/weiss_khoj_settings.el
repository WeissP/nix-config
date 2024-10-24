(require 'khoj)

(with-eval-after-load 'khoj
  (setq
   khoj-server-url "http://127.0.0.1:42110"
   khoj-index-directories '("/home/weiss/Documents/notes/papers/")
   )
  )

(provide 'weiss_khoj_settings)
