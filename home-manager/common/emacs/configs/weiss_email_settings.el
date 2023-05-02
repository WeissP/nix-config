(setq message-kill-buffer-on-exit t)

;; let msmtp know which address needs to be used
(setq mail-specify-envelope-from t)
(setq mail-envelope-from 'header)
(setq notmuch-fcc-dirs '((".*web\\.de" . "webde/Gesendet")
                         (".*rptu\\.de" . "rptu/Sent")
                         (".*cs\\.uni-kl\\.de" . "rptu_cs/Sent")
                         (".*" . "sent")
                         ))


(provide 'weiss_email_settings)
