(defun weiss-parse-wmctrl-desktops ()
  "DOCSTRING"
  (interactive)
  (let* ((raw (shell-command-to-string "wmctrl -d"))
         (lines (s-lines raw)))
    (-map
     (lambda (line)
       (let ((segs (s-split " " line)))                  
         (cons (-last-item segs) (string-to-number (car segs))) ))
     lines)
    ))

(defun weiss-wmctrl-send-active (desk-map desk)
  "DOCSTRING"
  (interactive)
  (shell-command (format "wmctrl -r :ACTIVE: -t %s" (cdr (assoc desk desk-map))))
  )

(defun weiss-tab-line-new-frame-with-bind-group-to-desk (desk-map desk &optional group)
  "DOCSTRING"
  (interactive)
  (select-frame (weiss-new-frame))
  (unless weiss-file-groups 
    (weiss-load-file-groups))
  (when group
    (weiss-load-file-group-to-tab group)
    (weiss-tab-bind-group group)
    (weiss-tab-next)    
    )
  (weiss-wmctrl-send-active desk-map desk)
  )

(defun weiss-tab-line--send-new-frame (desk-map desk job)
  "DOCSTRING"
  (interactive)
  (select-frame (weiss-new-frame))
  (funcall job)
  (weiss-wmctrl-send-active desk-map desk))

(setq weiss-tab-line-with-desk
      '(
        ("[1] Master Thesis (mt)" . (("1.1" . "mt-papers")
                                     ))
        ("[2] Master Thesis coding (mt)" . (("2.1" . "mt-join-component")
                                            ("2.1" . "mt-join-component")
                                            ("2.2" . "mt-join-component")
                                            ("2.2" . "mt-join-component")
                                            ("2.3" . ("/ssh:uni-cluster:/cluster-share/users/bai/storm/results/test/metric/""/home/weiss/projects/master_thesis/msc-thesis-bozhou-bai/deploy/readme.md"))
                                            ("2.3" . "mt-deploy")
                                            ("2.4" . "mt-join-test-utils")
                                            ("2.4" . "mt-join-test")
                                            ("2.4" . "mt-join-test")
                                            ("2.6" . "mt-join-env")
                                            ))
        ("[3] DIMA" .  (("3.1" . "dima-coll")
                        ("3.1" . "dima-coll")
                        ("3.4" . "dima-test")
                        ("3.4" . "dima-test")
                        ("3.5" . "dima-bench")
                        ("3.5" . "dima-bench")
                        ("3.6" . "dima-env")
                        ))
        ("[6] FeedTree FT" .  (("6.1" . "ftc-env")
                               ("6.1" . "ftc-src")
                               ))
        ("[7] Xmonad" .  (("7.1" . "xmonad")
                          ("7.1" . "xmonad")
                          ))
        ("[7] hledger-importer" .  (("7.1" . "he-types")
                                    ("7.1" . "he-lib")
                                    ("7.2" . "he-paypal")
                                    ("7.2" . "he-paypal")
                                    ("7.6" . "he-env")
                                    ))
        ("[8] finance" .  (("8.1" . ("/home/weiss/Documents/notes/20240114T174325--hledger-config__hledger.org" "/home/weiss/finance/journals/main.journal"))

                           ))        
        ("[设1] nix/emacs config" .  (("设" . "nix")
                                      ("设" . "emacs")
                                      ))
        ("[设3] glove80" .  (("设3" . "glove80")
                             ("设3" . "glove80")
                             ))        
        ("[记] Documents" .  (("记" . ("~/Documents/notes/20231128T160730--shopping-list.org" "~/Documents/notes/20241106T093923--todo.org"))))
        ("[1] DDM" .  (("1.1" . "ddm-lecture")
                       ("1.4" . "ddm-pre")
                       ("1.4" . "ddm-pre")
                       ("1.4" . "ddm-sheets")
                       ("1.5" . "ddm-pre")
                       ))
        )
      )

(add-to-list 'weiss-tab-line-with-desk
             (cons "daily"
                   (-concat 
                    (cdr (assoc "[记] Documents" weiss-tab-line-with-desk))
                    (cdr (assoc "[设1] nix/emacs config" weiss-tab-line-with-desk))
                    )))

(setq weiss-tab-line-consult-source
      (list
       :name     "tab-line"
       :category 'tab-line
       :action (lambda (cand) (cdr (assoc cand weiss-tab-line-with-desk)))
       :items (lambda () (-map #'car weiss-tab-line-with-desk))                
       ))

(defun weiss-tab-line-init-workspaces-prompt ()
  "DOCSTRING"
  (interactive)
  (let ((keys (completing-read-multiple
               (format-prompt "Tab line: " nil)
               (-map #'car weiss-tab-line-with-desk) nil nil nil 'tab-line))
        )
    (dolist (key keys) 
      (let ((pairs (cdr (assoc key weiss-tab-line-with-desk))))
        (weiss-tab-line-init-workspaces pairs)
        )      
      )
    )
  )

(defun weiss-tab-line-init-workspaces  (pairs)
  "DOCSTRING"
  (interactive)
  (let ((m (weiss-parse-wmctrl-desktops)))
    (dolist (p pairs) 
      (let* ((cdrp (cdr p)))
        (pcase cdrp
          ('nil (weiss-tab-line--send-new-frame m (car p) (lambda () (ignore))) )
          ((pred stringp)
           (weiss-tab-line--send-new-frame
            m (car p) 
            (lambda ()
              (let ((group cdrp))
                (unless weiss-file-groups 
                  (weiss-load-file-groups))
                (when group
                  (weiss-load-file-group-to-tab group)
                  (weiss-tab-bind-group group)
                  (weiss-tab-next)    
                  ) 
                )
              ))
           )
          ((pred listp)
           (dolist (f cdrp) 
             (weiss-tab-line--send-new-frame
              m (car p) (lambda () (find-file f) ))             
             )
           )
          (v (error "unmatched: %s" v)))

        )
      )    
    )
  )

(defun weiss-test ()
  "DOCSTRING"
  (interactive)
  (weiss-tab-line-init-workspaces weiss-tab-line-with-desk)
  )

(with-eval-after-load 'tab-line
  (wks-define-key
   wks-prompt-keymap
   ""
   '(
     ("t" . weiss-tab-line-init-workspaces-prompt)
     ))
  )


(provide 'weiss_tab-line_wmctrl)
