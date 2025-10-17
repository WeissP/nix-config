;; -*- lexical-binding: t -*-

;; (setq scala-cli-repl-program "scala-cli")
(defvar weiss--scala-cli-repl-module "_")
(defvar scala-cli-repl-format-config-path "/home/weiss/.emacs.d/scala-cli-repl/.scalafmt_repl.conf")

(defun weiss-scala-cli-formatted-region-text (start end)
  "DOCSTRING"
  (interactive "r")
  (save-current-buffer 
    (let ((code (s-trim (buffer-substring-no-properties start end)))
          (buf (get-buffer-create "*scala-cli-to-send*")))
      (with-current-buffer buf (erase-buffer))
      (call-process-region code nil "scalafmt" nil `(,buf "~/.scala-cli.err_out") nil "--config" scala-cli-repl-format-config-path "--stdin")
      (set-buffer buf)
      (buffer-string)
      )
    )
  )

(defun weiss-test (start end)
  "DOCSTRING"
  (interactive "r")
  ;; (message "start: %s, end: %s" start end)
  (message ": %s" (weiss-scala-cli-formatted-region-text start end))
  )

(defun weiss-test (start end)
  "DOCSTRING"
  (interactive "r")
  (let* ((start (save-excursion
		          (backward-paragraph)
		          (point)))
	     (end (save-excursion
	            (forward-paragraph)
	            (point)))
         (s (buffer-substring-no-properties  start end))
         )
    ;; (message "start: %s, end: %s" start end)
    (message "s: %s" s)

    (executable-find )
    (call-process-region "a\n" 1 "/nix/store/q2ciga09njfdcybjaly4ca8dfxkdbkvf-Dima-Join-dir/bin/scalafmt" nil  "*scala-cli-to-send*"  nil "--config" "/home/weiss/projects/dima_join/.scalafmt_repl.conf"  "--stdin" "--debug" "--non-interactive")

    ;; (shell-command-to-string )

    (message "code: %s"     (weiss-scala-cli-formatted-region-text s 313))
    )
  )

(defun weiss-scala-cli-repl-send-region (start end)
  "Send the region to the scala cli buffer.
Argument START the start region.
Argument END the end region."
  (interactive "r")
  (scala-cli-repl-check-process)
  (let ((code (weiss-scala-cli-formatted-region-text start end)))
    (when scala-cli-repl-use-closure-for-eval (comint-send-string scala-cli-repl-buffer-name "{\n"))
    (comint-send-string scala-cli-repl-buffer-name code)
    (when scala-cli-repl-use-closure-for-eval(comint-send-string scala-cli-repl-buffer-name "\n}"))
    (comint-send-string scala-cli-repl-buffer-name "\n")
    (message
     (format "Sent: %s..." (scala-cli-repl-code-first-line code)))
    )
  )
(advice-add 'scala-cli-repl-send-region :override #'weiss-scala-cli-repl-send-region)


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

(defun weiss-scala-cli-repl--mill (module-suffix)
  (interactive)
  (require 'scala-cli-repl)
  (ignore-errors (kill-buffer scala-cli-repl-buffer-name))      
  (let ((cb (buffer-name)))
    (find-file (concat (cdr (project-current)) "build.mill"))
    (with-current-buffer
        (apply 'term-ansi-make-term
               scala-cli-repl-buffer-name
               "mill"
               nil 
               `("-i" ,(concat weiss--scala-cli-repl-module module-suffix) ))
      (term-char-mode)
      (term-set-escape-char ?\C-x)
      (setq-local term-prompt-regexp scala-cli-repl-prompt-regex)
      (setq-local term-scroll-show-maximum-output t)
      (setq-local term-scroll-to-bottom-on-output t)
      (run-hooks 'scala-cli-repl-run-hook))
    (switch-to-buffer cb)
    (pop-to-buffer scala-cli-repl-buffer-name)
    )
  )

(defun weiss-scala-cli-repl-mill ()
  "DOCSTRING"
  (interactive)
  (weiss-scala-cli-repl--mill ".console")
  )

(defun weiss-scala-cli-repl-mill-test ()
  "DOCSTRING"
  (interactive)
  (weiss-scala-cli-repl--mill ".test.console")
  )

(with-eval-after-load 'scala-cli-repl
  (setq scala-cli-load-repl-in-sbt-context t)
  (add-hook 'scala-mode-hook #'scala-cli-repl-minor-mode)
  (add-hook 'scala-cli-repl-run-hook #'term-line-mode)

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
