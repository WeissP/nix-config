(with-eval-after-load 'ejc-sql
  (setq clomacs-httpd-default-port 8090
        ejc-sql-separator ";"
        ) 

  (require 'ejc-company)
  (setq ejc-complete-on-dot nil)  
  (setq-mode-local
   sql-mode
   company-backends
   '(ejc-company-backend))

  (add-hook 'ejc-sql-minor-mode-hook
            (lambda ()
              (ejc-eldoc-setup)  ;; no width limit
              (ejc-set-column-width-limit nil)))

  (advice-add 'ejc-cancel-query :before #'weiss-select-mode-turn-off)

  
  (setq ejc-sql-lib-path
        (clojure-project-dir
         (file-name-directory (find-library-name "ejc-sql"))))
  (setq ejc-repl-dir "/tmp/ejc-sql")
  (unless (file-directory-p ejc-repl-dir)
    (copy-directory ejc-sql-lib-path ejc-repl-dir nil t t)
    (set-file-modes ejc-repl-dir 493))
  (defun find-library-name-overriding-ejc (lib-name)
    "replace the library dir of ejc-sql"
    (when (string= lib-name "ejc-sql") (format "%s/ejc-sql.el" ejc-repl-dir)))
  (advice-add 'find-library-name :before-until #'find-library-name-overriding-ejc)

  (ejc-create-connection
   "digivine"
   :classpath "[/Users/bozhoubai/.m2/repository/postgresql/postgresql/9.3-1102.jdbc41/postgresql-9.3-1102.jdbc41.jar]"
   :password ""
   :user "bozhoubai"
   :port "5555"
   :host "localhost"
   :dbname "digivine"
   :dbtype "postgresql")

  (ejc-create-connection
   "ms"
   :classpath "[/Users/bozhoubai/.m2/repository/postgresql/postgresql/9.3-1102.jdbc41/postgresql-9.3-1102.jdbc41.jar]"
   :password ""
   :user "bozhoubai"
   :port "7700"
   :host "localhost"
   :dbname "ms"
   :dbtype "postgresql")  
  )

(provide 'weiss_ejc-sql_settings)
