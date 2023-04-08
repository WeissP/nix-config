(with-eval-after-load 'org
  (setq org-link-frame-setup
        '((vm . vm-visit-folder)
          (vm-imap . vm-visit-imap-folder)
          (gnus . gnus)
          (file . find-file)
          (wl . wl-frame))

        org-file-apps
        '(("\\.mm\\'" . default)
          ("\\.x?html?\\'" . "google-chrome-stable  %s")
          ("\\.pdf\\'" . emacs)
          ("\\.mp4\\'" . "mpv \"%s\"")
          ("\\.MP4\\'" . "mpv \"%s\"")
          ("\\.mov\\'" . "mpv \"%s\"")
          ("\\.MOV\\'" . "mpv \"%s\"")
          ("\\.txt\\'" . emacs)
          ("\\.xopp\\'" . "xournalpp \"%s\"")
          (auto-mode . emacs)))
  )

(provide 'weiss_org_open)



