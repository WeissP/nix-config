(with-eval-after-load 'chatu-xournal 
  (defun weiss-new-xournal ()
    "DOCSTRING"
    (interactive)
    (let ((name (read-string "xournal name: ")))
      (insert (format "#+chatu: :xournal \"%s\" :page 1 :output-ext png\n#+results:\n#+ATTR_ORG: :width 500" name))      
      (forward-line -2)
      (call-interactively 'chatu-open)
      ))

  (defun weiss-xournal-open-or-new ()
    "DOCSTRING"
    (interactive)
    (if-let ((keyword-plist (chatu-keyword-plist))
             )
        (chatu-xournal-open keyword-plist)
      (weiss-new-xournal)
      )
    )
  )

(provide 'weiss_chatu-xournal_settings)
