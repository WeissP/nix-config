(electric-pair-mode 1)
(with-eval-after-load 'elec-pair
  (setq electric-pair-open-newline-between-pairs t)
  (defun weiss-electric-pair--ignore-lt (c) (char-equal c ?<))
  (with-eval-after-load 'org
    (setq-mode-local
     org-mode
     electric-pair-inhibit-predicate #'weiss-electric-pair--ignore-lt
     )    
    )
  )

(provide 'weiss_elec-pair_settings)




