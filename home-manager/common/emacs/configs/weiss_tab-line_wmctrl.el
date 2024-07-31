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
      '(("[4] Digivine" .  (("4.1" . "dv-rs-fed")
                            ("4.1" . "dv-rs-fed")
                            ("4.1" . "dv-api")
                            ("4.2" . "dv-macros")
                            ("4.3" . ("/home/weiss/projects/digiVine/federated-api/src/main/java/rptu/digivine/federatedapi/server/api/TerrainApiImpl.java"))
                            ("4.5" . ("/home/weiss/projects/digiVine/federated-api/CS-BA-1034_Bachelor_Le.pdf"))
                            ("4.6" . "dv-nix")
                            ))
        ("[4] Digivine federated server lib" .  (("4.1" . "dv-fed-server")
                                                 ("4.1" . "dv-fed-filter")
                                                 ("4.1" . "dv-fed-filter")
                                                 ("4.2" . "dv-fed-template")
                                                 ("4.2" . "dv-fed-template")
                                                 ("4.3" . "dv-fed-macros")
                                                 ("4.3" . "dv-fed-macros")
                                                 ("4.4" . "dv-api-spec")
                                                 ("4.5" . ("/home/weiss/projects/digiVine/federated-api/CS-BA-1034_Bachelor_Le.pdf"  "/home/weiss/Documents/notes/misc/notes/20231203T202231--digivine__digivine_meta.org"))
                                                 ("4.6" . "dv-fed-env")
                                                 ("4.6" . "dv-fed-env")
                                                 ("4.6" . ("/home/weiss/projects/digiVine/federated-api/server_generator/config.yaml"))
                                                 ))
        ("[5] Digivine federated server binary" .  (("5.1" . "dv-fed-src")
                                                    ("5.1" . "dv-fed-src")
                                                    ))
        ("[1] Guided Research" .  (("1.1" . "gr-polars-src")
                                   ("1.1" . "gr-polars-src")
                                   ("1.2" . ("/home/weiss/projects/guided-research/guided-research-rs/data/" "/home/weiss/projects/guided-research/guided-research-rs/analysis/individual/nursery/"))
                                   ("1.3" . ("/home/weiss/projects/guided-research/guided-research-rs/python/main.py"))
                                   ("1.4" . ("/home/weiss/Documents/notes/academic/writing/guided_research/20240726T092753--report__academic_guidedresearch.org" "/home/weiss/Documents/notes/academic/notes/20240418T214915--guided-research__academic_db.org"))
                                   ("1.5" . ("/home/weiss/Documents/notes/academic/writing/guided_research/20240726T092753--report__academic_guidedresearch.pdf"))
                                   ("1.6" . "gr-polars-env")
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
        ("[6] Subtube ST" .  (("6.1" . "st-types")
                              ("6.1" . "st-types")
                              ("6.1" . "st-types")
                              ("6.2" . "st-nix")
                              ("6.2" . "st-nix")
                              ("6.3" . "st-db")
                              ("6.3" . "st-db")
                              ("6.3" . "st-db")
                              ("6.4" . "st-types")
                              ("6.4" . "st-invidious")
                              ("6.5" . "st-api")
                              ("6.5" . "st-api")
                              ("6.5" . "st-types")
                              ("6.6" . "st-test")
                              ("6.6" . "st-test")
                              ))
        ("[7] Xmonad" .  (("7.1" . "wx-src")
                          ("7.1" . "wx-src")
                          ("7.4" . "weissXmonad")))
        ("[7] hledger-importer" .  (("7.1" . "he-types")
                                    ("7.1" . "he-lib")
                                    ("7.2" . "he-paypal")
                                    ("7.2" . "he-paypal")
                                    ("7.6" . "he-env")
                                    ))
        ("[设1] nix/emacs config" .  (("设" . "nix")
                                      ("设" . "emacs")
                                      ("设" . nil)))
        ("[设3] glove80" .  (("设3" . "glove80")
                             ("设3" . "glove80")
                             ))        
        ("[记] Documents" .  (("记" . nil)))
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
