(with-eval-after-load 'notmuch
  (require 'org-msg)
)

(with-eval-after-load 'org-msg
  (setq org-msg-options "html-postamble:nil H:5 num:nil ^:{} toc:nil author:nil email:nil \\n:t"
	    org-msg-startup "hidestars indent inlineimages"
	    org-msg-greeting-fmt "\nHello%s,\n\n"
	    org-msg-recipient-names '(("weissbai@web.de" . "Bozhou Bai")
                                  ("bai@rptu.de" . "Bozhou Bai"))
	    org-msg-greeting-name-limit 3
	    org-msg-default-alternatives '((new		. (text html))
				                       (reply-to-html	. (text html))
				                       (reply-to-text	. (text)))
	    org-msg-convert-citation t
	    org-msg-signature "
 
Best Regards,

#+begin_signature 
Bozhou Bai
#+end_signature")

  (org-msg-mode)
  )

(provide 'weiss_org-msg-mode_settings)
