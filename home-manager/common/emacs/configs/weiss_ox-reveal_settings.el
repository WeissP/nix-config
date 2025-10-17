(with-eval-after-load 'org
  (require 'ox-reveal)
  )

(with-eval-after-load 'ox-reveal
  (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")
  )

(provide 'weiss_ox-reveal_settings)
