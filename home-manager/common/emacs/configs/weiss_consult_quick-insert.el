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
     :pairs
     (
      (
       :name "scala with session"
       :pair ("#+BEGIN_SRC scala :session *scala-cli*" . "#+END_SRC")
       :new-line t
       )
      (
       :name "python with session"
       :pair ("#+BEGIN_SRC python :session :results output" . "#+END_SRC")
       :new-line t
       )
      (
       :name "clojure"
       :pair ("#+BEGIN_SRC clojure" . "#+END_SRC")
       :new-line t
       )
      (
       :name "Special Block: proposition"
       :pair ("#+BEGIN_proposition" . "#+END_proposition")
       :new-line t
       )
      (
       :name "Special Block: lemma"
       :pair ("#+BEGIN_lemma" . "#+END_lemma")
       :new-line t
       )
      (
       :name "Special Block: theorem"
       :pair ("#+BEGIN_theorem" . "#+END_theorem")
       :new-line t
       )
      (
       :name "Special Block: definition"
       :pair ("#+ATTR_LATEX: :options []\n#+BEGIN_definition" . "#+END_definition")
       :new-line t
       )
      (
       :name "Special Block: IEEEproof"
       :pair ("#+BEGIN_IEEEproof" . "#+END_IEEEproof")
       :new-line t
       )
      (
       :name "rust"
       :pair ("#+BEGIN_SRC rust" . "#+END_SRC")
       :new-line t
       )
      (
       :name "yaml"
       :pair ("#+BEGIN_SRC yaml" . "#+END_SRC")
       :new-line t
       )
      (
       :name "scala"
       :pair ("#+BEGIN_SRC scala" . "#+END_SRC")
       :new-line t
       )
      (
       :name "Elisp"
       :pair ("#+BEGIN_SRC elisp" . "#+END_SRC")
       :new-line t
       )
      (
       :name "Markdown"
       :pair ("#+BEGIN_SRC markdown" . "#+END_SRC")
       :new-line t
       )
      (
       :name "R with session"
       :pair ("#+BEGIN_SRC R :session *R* :results output" . "#+END_SRC")
       :new-line t
       )
      (
       :name "Shell"
       :pair ("#+BEGIN_SRC sh" . "#+END_SRC")
       :new-line t
       )
      (
       :name "Nushell"
       :pair ("#+BEGIN_SRC nushell" . "#+END_SRC")
       :new-line t
       )
      (
       :name "java"
       :pair ("#+BEGIN_SRC java" . "#+END_SRC")
       :new-line t
       )
      (
       :name "Haskell"
       :pair ("#+BEGIN_SRC haskell" . "#+END_SRC")
       :new-line t
       )
      (
       :name "R plot"
       :pair ("#+BEGIN_SRC R :results output graphics file :file images/plot_.png " . "#+END_SRC")
       :new-line t
       )
      (
       :name "Denote Single File"
       :pair ("#+BEGIN: denote-files :regexp \"ol: " . "\" :no-front-matter nil :add-links t\n#+END")
       :new-line nil
       )
      (
       :name "Denote Insert Files"
       :pair ("#+BEGIN: denote-files :regexp \"ol: " . "\" :sort-by-component signature :reverse-sort nil :no-front-matter nil :add-links t  :file-separator t\n#+END")
       :new-line nil
       )
      (
       :name "Denote Insert Links"
       :pair ("#+BEGIN: denote-links :regexp \"ol: " . "\" :sort-by-component signature :reverse-sort nil :no-front-matter nil :add-links t  :file-separator t\n#+END")
       :new-line nil
       )
      )
     ))
   ("latex environment" .
    (
     :narrow ?l
     :pairs
     (
      (
       :name "⌈ ceil ⌉"
       :pair ("\\lceil " . " \\rceil")
       )
      (
       :name "& newline in align Environment \\"
       :pair ("& =" . " \\\\")
       )
      (
       :name "⌊ floor ⌋"
       :pair ("\\lfloor " . " \\rfloor")
       )
      (
       :name "asymptotic big O notation"
       :pair ("\\mathcal{O}(" . ")")
       )
      (
       :name "red text color"
       :pair ("\\textcolor{red}{" . "}")
       )
      (
       :name "operatorname"
       :pair ("\\operatorname{" . "}")
       )
      (
       :name "mathbf"
       :pair ("\\mathbf{" . "}")
       )
      (
       :name "mathrm"
       :pair ("\\mathrm{" . "}")
       )
      (
       :name "mathbb"
       :pair ("\\mathbb{" . "}")
       )
      (
       :name "reference"
       :pair ("\ \\pmb{\\mathit{" . "}}")
       )
      (
       :name "underset"
       :pair ("\\underset{" . "}")
       )
      (
       :name "Decoration with number"
       :pair ("\\stackrel{\\pmb{\\mathit{1}}}{ " . " }")
       )
      (
       :name "texttt"
       :pair ("\\texttt{" . "}")
       )
      (
       :name "bigg paren"
       :pair ("\\bigg( " . "\\bigg)")
       )
      (
       :name "Big paren"
       :pair ("\\Big( " . "\\Big)")
       )
      (
       :name "text"
       :pair ("\\text{ " . " }")
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
       :name "bar"
       :pair ("\\bar{" . "}")
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
                        (if (plist-member pair-entry :new-line)
                            (plist-get pair-entry :new-line)
                          (plist-get pl :new-line)                          
                          )
                        ))
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
   :add-history (seq-some #'thing-at-point '(region symbol))
   )
  )

(provide 'weiss_consult_quick-insert)
