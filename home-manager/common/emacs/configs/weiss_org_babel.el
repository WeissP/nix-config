(with-eval-after-load 'org
  (setq org-confirm-babel-evaluate nil
        org-src-fontify-natively t
        org-src-tab-acts-natively t)

  (require 'ob-R)
  (require 'ob-ammonite)
  (require 'ob-shell)
  (require 'ob-python)
  (setq load-language-list
        '((emacs-lisp . t)
          (shell . t)
          (python . t)
          (ruby . t)
          (ob-fsharp . t)
          (ob-javascript . t)
          (ob-go . t)
          (ob-rust . t)
          (ob-java . t)
          (ob-sql-mode . t)
          (ob-ammonite . t)
          (scala . t)
          (js . t)
          (css . t)
          (sass . t)
          (C . t)
          (plantuml . t)
          (R . t)
          (yaml . t)
          (agda2 . t)
          (conf-toml . t)
          (elixir . t)
          (maxima . t)
          (nix . t)))
  
  )

(provide 'weiss_org-babel)
