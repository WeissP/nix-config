(defun weiss-notmuch-first-refresh-then-retrive ()
  "DOCSTRING"
  (interactive)
  (notmuch-poll-and-refresh-this-buffer)
  (weiss-email-retrive)
  )

(defun weiss-email-retrived (process signal)
  (when (memq (process-status process) '(exit signal))
    (setq weiss-email-retriving nil)
    (message "email retrived!" )
    (shell-command-sentinel process signal)))

(defun weiss-email-retrive ()
  "DOCSTRING"
  (interactive)
  (unless weiss-email-retriving
    (let* ((output-buffer (generate-new-buffer "*Retriving email*"))
           (proc (progn
                   (message "retriving email..." )
                   (setq weiss-email-retriving t)
                   (async-shell-command "mbsync -a" output-buffer)
                   (get-buffer-process output-buffer))))
      (if (process-live-p proc)
          (set-process-sentinel proc #'weiss-email-retrived)
        (message "mbsync is not running")))
    )
  )

(defun weiss-notmuch-read ()
  "DOCSTRING"
  (interactive)
  (notmuch-tree-tag (list "-unread"))
  )

(defun weiss-notmuch-next (&rest args)
  "DOCSTRING"
  (interactive)
  (call-interactively 'notmuch-tree-next-matching-message)  
  )

(defun weiss-notmuch-tree (&optional query query-context target buffer-name
			                         open-target unthreaded parent-buffer oldest-first)
  "Always set oldest-first to t"
  (interactive)
  (unless query
    (setq query (notmuch-read-query (concat "Notmuch "
					                        (if unthreaded "unthreaded " "tree ")
					                        "view search: "))))
  (notmuch-tree query query-context target buffer-name
		        open-target unthreaded parent-buffer t)
  )

(with-eval-after-load 'notmuch
  (setq
   notmuch-search-oldest-first nil
   notmuch-always-prompt-for-sender t
   notmuch-fcc-dirs '((".*web\\.de" . "webde/Gesendet")
                      (".*rptu\\.de" . "rptu/Sent")
                      (".*cs\\.uni-kl\\.de" . "rptu_cs/Sent")
                      (".*gmail\\.com" . "gmail/[Gmail]/Sent Mail")
                      (".*" . "sent")
                      ))

  (setq notmuch-saved-searches
        `(
          (:name " " :query "tag:unread AND is:inbox AND NOT is:unimportant" :key ,(kbd "n") :search-type tree :sort-order oldest-first)
          (:name "📌" :query "tag:pinned" :key ,(kbd "p") :search-type tree :sort-order oldest-first)
          (:name " " :query "tag:unread AND is:inbox AND is:unimportant AND NOT (is:newsletter or is:mailing_list)" :key ,(kbd "u") :search-type tree :sort-order oldest-first)
          (:name "  Newsletter" :query "is:newsletter" :key ,(kbd "r n") :search-type tree :count-query "is:newsletter AND is:unread" :sort-order newest-first)
          (:name " RPTU" :query "tag:RPTU AND is:inbox AND NOT is:unimportant" :key ,(kbd "i r") :search-type tree :sort-order newest-first)
          (:name " RPTU_CS" :query "tag:RPTU_CS AND is:inbox AND NOT is:unimportant" :key ,(kbd "i c") :search-type tree :sort-order newest-first)
          (:name " WebDE" :query "tag:WebDE AND is:inbox AND NOT is:unimportant" :key ,(kbd "i w") :search-type tree :sort-order newest-first)
          (:name " 163" :query "tag:163 AND is:inbox AND NOT is:unimportant" :key ,(kbd "i m") :search-type tree :sort-order newest-first)
          (:name " Gmail" :query "tag:gmail AND is:inbox AND NOT is:unimportant" :key ,(kbd "i g") :search-type tree :sort-order newest-first)
          ))

  (setq notmuch-show-empty-saved-searches t
        notmuch-show-logo nil)

  (advice-add 'weiss-notmuch-read :after #'weiss-notmuch-next)


  (defvar weiss-email-retriving nil)

  (add-to-list 'display-buffer-alist (cons "*Retriving email*" (cons #'display-buffer-no-window nil)))


  )


(provide 'weiss_notmuch_settings)
