(setq message-kill-buffer-on-exit t)

;; let msmtp know which address needs to be used
(setq mail-specify-envelope-from t)
(setq mail-envelope-from 'header)
(setq message-auto-save-directory "~/Documents/mails")

(provide 'weiss_email_settings)
