;; -*- lexical-binding: t -*-

(require 'scala-cli-repl)
;; (setq scala-cli-repl-program "scala-cli")

(with-eval-after-load 'scala-cli-repl
  (setq scala-cli-load-repl-in-sbt-context t)
  (add-hook 'scala-cli-repl-run-hook #'term-line-mode)

  (defun weiss-scala-cli-send-line ()
    "DOCSTRING"
    (interactive)
    (scala-cli-repl-send-region (line-beginning-position) (line-end-position))
    )

  (defun weiss-scala-cli-send-paragraph ()
    "Send the current paragraph to repl"
    (interactive)
    (let ((start (save-excursion
		           (backward-paragraph)
		           (point)))
	      (end (save-excursion
	             (forward-paragraph)
	             (point))))
      (scala-cli-repl-send-region start end)))

  (defvar weiss--scala-cli-repl-module "_")

  (defun weiss-scala-cli-repl-mill ()
    (interactive)
    (ignore-errors (kill-buffer scala-cli-repl-buffer-name))      
    (find-file (concat (cdr (project-current)) "build.sc"))
    (with-current-buffer
        (apply 'term-ansi-make-term
               scala-cli-repl-buffer-name
               "mill"
               nil
               `("-i" ,(concat weiss--scala-cli-repl-module ".test.console") ))
      (term-char-mode)
      (term-set-escape-char ?\C-x)
      (setq-local term-prompt-regexp scala-cli-repl-prompt-regex)
      (setq-local term-scroll-show-maximum-output t)
      (setq-local term-scroll-to-bottom-on-output t)
      (run-hooks 'scala-cli-repl-run-hook))
    (switch-to-buffer scala-cli-repl-buffer-name))

  (require 'ob-scala-cli)
  (let ((with-circe
         (lambda (pkgs)
           (-map (lambda (pkg) (format "io.circe::%s::0.15.0-M1" pkg)) 
                 pkgs)))
        )    
    (setq ob-scala-cli-default-params
          `(:dep ,(-concat
                   '("io.circe::circe-optics::0.15.0")
                   (funcall with-circe '("circe-core" "circe-generic" "circe-parser")))
                 ))
    )
  )

(provide 'weiss_scala-cli-repl_settings)
