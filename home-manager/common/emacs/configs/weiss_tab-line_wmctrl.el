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
      '(("[1] logic seminar" . (("1.1" . ("/home/weiss/Documents/notes/academic/logic_seminar/report/20240810T081910--report__academic_logic_seminar.org" "/home/weiss/Documents/notes/academic/logic_seminar/notes/20240526T102453==8--position-wise-realizable__academic_barcelo2023_def.org" "/home/weiss/Documents/chats/#Evaluation of Linear Temporal Logic Formulas over Word Sequences#.chat"))
                                ("1.2" . ("/home/weiss/Documents/notes/academic/logic_seminar/report/20240810T081910--report__academic_logic_seminar.pdf"))
                                ("1.3" . ("/home/weiss/Documents/notes/academic/documents/Barcelo2023.pdf"))

                                ))
        ("[4] Digivine" .  (("4.1" . "dv-rs-fed")
                            ("4.1" . "dv-rs-fed")
                            ("4.1" . "dv-api")
                            ("4.2" . "dv-macros")
                            ("4.3" . ("/home/weiss/projects/digiVine/federated-api/src/main/java/rptu/digivine/federatedapi/server/api/TerrainApiImpl.java"))
                            ("4.5" . ("/home/weiss/projects/digiVine/federated-api/CS-BA-1034_Bachelor_Le.pdf"))
                            ("4.6" . "dv-nix")
                            ))
        ("[4] Digivine federated server lib" .  (("4.1" . "dv-fed-server")
                                                 ("4.1" . "dv-fed-server")
                                                 ("4.1" . "dv-fed-filter")
                                                 ("4.2" . "dv-fed-template")
                                                 ("4.2" . "dv-fed-template")
                                                 ("4.3" . "dv-fed-macros")
                                                 ("4.3" . "dv-fed-macros")
                                                 ("4.4" . "dv-api-spec")
                                                 ("4.4" . "dv-api-spec")
                                                 ("4.5" . ("/home/weiss/projects/digiVine/federated-api/CS-BA-1034_Bachelor_Le.pdf"  "/home/weiss/Documents/notes/misc/notes/20231203T202231--digivine__digivine_meta.org"))
                                                 ("4.6" . "dv-fed-env")
                                                 ("4.6" . "dv-fed-env")
                                                 ("4.6" . ("/home/weiss/projects/digiVine/federated-api/server_generator/config.yaml"))
                                                 ))
        ("[5] Digivine federated server binary" .  (("5.1" . "dv-fed-src")
                                                    ("5.1" . "dv-fed-src")
                                                    ("5.3" . "api-inspector")
                                                    ))
        ("[1] Guided Research" .  (("1.1" . "gr-polars-src")
                                   ("1.1" . "gr-greedy")
                                   ("1.1" . "gr-greedy")
                                   ("1.2" . ("/home/weiss/projects/guided-research/guided-research-rs/data/" "/home/weiss/projects/guided-research/guided-research-rs/analysis/individual/nursery/"))
                                   ("1.3" . ("/home/weiss/projects/guided-research/guided-research-rs/python/main.py"))
                                   ("1.4" . ("/home/weiss/Documents/notes/academic/notes/20240418T214915--guided-research__academic_db.org"))
                                   ("1.6" . "gr-polars-env")
                                   ))
        ("[2] Guided Research Report" .
         (("2.1" . ("/home/weiss/Documents/notes/academic/writing/guided_research/20240726T092753--report__academic_guidedresearch.org"))
          ("2.2" . ("/home/weiss/Documents/notes/academic/writing/guided_research/20240726T092753--report__academic_guidedresearch.pdf" "/home/weiss/Documents/notes/academic/writing/guided_research/20240726T092753--report__academic_guidedresearch.tex"))
          ))
        ("[3] MPI Hiwi" .  (("3.1" . ("/home/weiss/Documents/notes/academic/trace_theory/TheBookOfTraces/20240510T145448--TheBookOfTraces__academic_tbot_trace.pdf"))
                            ("3.4" . ("/home/weiss/Documents/notes/academic/trace_theory/questions/20240802T184543--questions__logic_mpi.pdf"))                            
                            ("3.6" . "mpi-trace")
                            ("3.6" . "mpi-trace")
                            ))
        ("[5] Weather Data Manager WDM" .  (("5.1" . "wdm-field")
                                            ("5.1" . "wdm-station")
                                            ("5.1" . "wdm-weather-data")
                                            ("5.2" . "wdm-dwd")
                                            ("5.2" . "wdm-dvclient")
                                            ("5.3" . "wdm-inte")
                                            ("5.3" . "wdm-main")
                                            ("5.4" . "wdm-env")
                                            ("5.5" . "wdm-mock")
                                            ("5.5" . "wdm-test")
                                            ))
        ("[6] FeedTree FT" .  (("6.1" . "ft-types")
                               ("6.1" . "ft-src")
                               ("6.2" . "ft-tests")
                               ("6.2" . "ft-tests")
                               ("6.3" . "ft-tests")
                               ("6.3" . "st-help")
                               ("6.5" . "ft-proto")
                               ("6.5" . "ft-proto")
                               ("6.6" . "st-nix")
                               ("6.6" . "st-nix")
                               ))
        ("[7] Xmonad" .  (("7.1" . "xmonad")
                          ("7.1" . "xmonad")
                          ("7.6" . "xmonad-nix")))
        ("[7] hledger-importer" .  (("7.1" . "he-types")
                                    ("7.1" . "he-lib")
                                    ("7.2" . "he-paypal")
                                    ("7.2" . "he-paypal")
                                    ("7.6" . "he-env")
                                    ))
        ("[8] finance" .  (("8.1" . ("/home/weiss/Documents/notes/misc/notes/20240114T174325--hledger-config__hledger.org" "/home/weiss/finance/journals/main.journal"))

                           ))        
        ("[设1] nix/emacs config" .  (("设" . "nix")
                                      ("设" . "emacs")
                                      ("设" . nil)))
        ("[设3] glove80" .  (("设3" . "glove80")
                             ("设3" . "glove80")
                             ))        
        ("[记] Documents" .  (("记" . ("/home/weiss/Documents/notes/misc/notes/20231128T160730--shopping-list.org"))))
        )
      )


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
