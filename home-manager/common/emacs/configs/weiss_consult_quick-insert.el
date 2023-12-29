;; -*- lexical-binding: t -*-
(require 'consult)
(require 's)
(require 'dash)

(setq
 quick-insert-candidates
 '(
   ("org source code" .
    (
     :narrow ?s
     :new-line t
     :pairs
     (
      (
       :name "Elisp"
       :pair ("#+BEGIN_SRC elisp" . "#+END_SRC")
       )
      (
       :name "R with session"
       :pair ("#+BEGIN_SRC R :session *R* :results output" . "#+END_SRC")
       )
      (
       :name "Shell"
       :pair ("#+BEGIN_SRC sh" . "#+END_SRC")
       )
      (
       :name "Haskell"
       :pair ("#+BEGIN_SRC haskell" . "#+END_SRC")
       )
      (
       :name "Denote Single File"
       :pair ("#+BEGIN: denote-files :regexp \"\" :no-front-matter nil :add-links t" . "#+END")
       )
      (
       :name "Denote Insert Files"
       :pair ("#+BEGIN: denote-files :regexp \"\" :sort-by-component identifier :reverse-sort nil :no-front-matter nil :add-links t  :file-separator t" . "#+END")
       )
      )
     ))
   ("latex environment" .
    (
     :narrow ?l
     :pairs
     (
      (
       :name "mathbf"
       :pair ("\\mathbf{" . "}")
       )
      (
       :name "texttt"
       :pair ("\\texttt{" . "}")
       )
      (
       :name "mathcal"
       :pair ("\\mathcal{" . "}")
       )
      (
       :name "hat"
       :pair ("\\hat{" . "}")
       )
      (
       :name "underline"
       :pair ("\\underline{" . "}")
       )
      (
       :name "emph"
       :pair ("\\emph{" . "}")
       )
      )
     ))
   )
 )
(defvar quick-insert--consult-sources)

(defun quick-insert--pair (left right &optional new-line)
  "Insert brackets around region"
  (let ((text (when (use-region-p)
                (delete-and-extract-region (region-beginning) (region-end))
                ))
        (p (point))
        )
    (insert (s-join (if new-line "\n" "") (list left text right)))
    (if text        
        (goto-char p)
      (goto-char (+ (if new-line 1 0) (length left) p))
      )
    )
  )

(defun quick-insert--generate-consult-source (name)
  "DOCSTRING"
  (interactive)
  (let* ((pl (cdr (assoc name quick-insert-candidates)))
         (pairs (plist-get pl :pairs))
         (get-pair-entry (lambda (name cand)
                           (--first (string= (plist-get it :name) cand) pairs)))
         (get-pair (lambda (pair-entry) (plist-get pair-entry :pair)))
         (is-new-line (lambda (pair-entry)
                        (or (plist-get pair-entry :new-line)
                            (plist-get pl :new-line)
                            )))
         )
    (list
     :name     name
     :narrow   (plist-get pl :narrow)
     :category 'quick-insert
     :annotate (lambda (cand)
                 (let* ((pe (funcall get-pair-entry name cand))
                        (pair (funcall get-pair pe))
                        (new-line (funcall is-new-line pe)))                   
                   (format "%s %s %s"
                           (car pair)
                           (if new-line "▤" "⋯")
                           (cdr pair))
                   )
                 )
     :action (lambda (cand)
               (let* ((pair-entry
                       (--first (string= (plist-get it :name) cand) pairs))
                      (pair (plist-get pair-entry :pair)))
                 (quick-insert--pair
                  (car pair) (cdr pair)
                  (or (plist-get pair-entry :new-line)
                      (plist-get pl :new-line)
                      ))
                 ))
     :items (lambda () (--map (plist-get it :name) pairs))                
     )
    ))

(defun quick-insert-prepare-sources ()
  "DOCSTRING"
  (interactive)
  (let* ((names (-map #'car quick-insert-candidates))
         (sources (-map #'quick-insert--generate-consult-source names))
         )    
    (setq quick-insert--consult-sources (-zip-pair names sources))
    ))
(quick-insert-prepare-sources)

(defun quick-insert-consult (&rest names)
  "DOCSTRING"
  (interactive)
  (consult--multi
   (->>
    quick-insert--consult-sources
    (--filter (member (car it) names))
    (-map #'cdr)
    )
   :require-match t
   :prompt "Quick Insert: "
   :history 'consult-quick-insert-history
   :add-history (seq-some #'thing-at-point '(region symbol)))
  )

(provide 'weiss_consult_quick-insert)
