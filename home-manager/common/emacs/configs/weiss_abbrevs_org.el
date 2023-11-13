(with-eval-after-load 'org
  (when (boundp 'org-mode-abbrev-table)
    (clear-abbrev-table org-mode-abbrev-table))

  (define-abbrev-table 'org-mode-abbrev-table
    '(
      ("ta" ":tangle ")
      ("wa" "WhatsApp")
;;;;; symbols
      ("pc" "Pros & Cons for ▮:\n*＋* \n*－* cons ")    
      ("norm" "∥ ▮ ∥")    
      ("o" "𝒪(▮)")    
      ("nd" "𝒩(0,σ²_▮)")    

;;;;; roam
      ("ro" "#+roam_▮: ")
;;;;; org config
      ("attr" "#+ATTR_org: :")
      ("img" "#+ATTR_org: :width 600")
      ("cap" "#+CAPTION:▮\n#+NAME: fig:")
      ("cmt" "COMMENT ")
      ("nexp" " :noexport:")
;;;;; latex
      ("ltxeq" "\\begin{equation*}\n▮\n\\end{equation*}" weiss--ahf-indent)    
      ("ltxal" "\\begin{align*}\n▮\n\\end{align*}" weiss--ahf-indent)    
      ("qed" "\\(\\hfill\\blacksquare\\)" weiss--ahf)    
      ("ltxeqal" "\\begin{equation}\n\\begin{aligned}\n▮\n\\end{aligned}\n\\end{equation}" weiss--ahf-indent)    
      ("ltxtb" "#+ATTR_LaTeX: :align |r|r|r|r|r|" weiss--ahf-indent)    
      ("ltxmg" "#+ATTR_Latex: :options [leftmargin=▮8ex]" weiss--ahf-indent)    
      ("ltximg" "#+ATTR_LATEX:  :width 0.9\\textwidth :center nil" weiss--ahf-indent)    
      ("ltxmt" "#+ATTR_LATEX: :options xleftmargin=8ex" weiss--ahf-indent)    
      ("ltxalg" "#+CAPTION:▮\n#+NAME: alg:\n\\begin{algorithm}\n\\SetKw{bk}{break}\n\\SetKwFunction{len}{len} \n\\SetKwInOut{INPUT}{Input}\n\\SetKwInOut{OUTPUT}{Output}\n\\INPUT{}\n\\OUTPUT{}\n\\BlankLine\n\\end{algorithm}\n" weiss--ahf-indent)    
      ("orgimg" "#+ATTR_ORG: :width 600" weiss--ahf-indent)    
      ("cc" "$\\color{code}\\texttt{▮}$" weiss--ahf-indent)    
;;;;; ref
      ("rfig" "#+ATTR_LATEX: :width 8cm\n#+CAPTION:▮\n#+NAME: fig:" weiss--ahf)
      ("rl" "#+CAPTION:▮\n#+NAME:" weiss--ahf)
      ("rlst" "#+CAPTION:▮\n#+NAME: lst:\n#+begin_src\n\n#+end_src\n" weiss--ahf)
      ("req" "\\begin{equation} \\label{eq:▮}\n\n\\end{equation}" weiss--ahf)
      ("rhd" ":PROPERTIES:\n:CUSTOM_ID: sec:▮\n:END:" weiss--ahf)
;;;;; emoji
      ("ej" "😂" weiss--ahf)
;;;;; for English language
      ("intr" "introduction" weiss--ahf)    
      ("ex" "example" weiss--ahf)    
      ("foa" "First of all " weiss--ahf)    
      ("fst" "the first " weiss--ahf)    
      ("json" "JSON " weiss--ahf)    
      ("joda" "JODA " weiss--ahf)    
      ("algo" "algorithm" weiss--ahf)
      ("prop" "properties" weiss--ahf)
      ("lhd" "likelihood " weiss--ahf)
;;;;; for Germany language
      ("ht" "heute" weiss--ahf)
      ("ad" "außerdem" weiss--ahf)
      ("ag" "Aufgabe" weiss--ahf)
      ("as" "Ausgabe" weiss--ahf)
      ("bh" "Behauptung" weiss--ahf)
      ("bdi" "Beweis durch Induktion" weiss--ahf)
      ("bj" "bis jetzt")
      ("bsp" "Beispiel" weiss--ahf)
      ("def" "Definition" weiss--ahf)
      ("dw" "deswegen")
      ("eb" "ein bisschen")
      ("ef" "einfach" weiss--ahf)
      ("en" "entweder")
      ("edl" "endlich ")
      ("fm" "Familie" weiss--ahf)
      ("ft" "fertig" weiss--ahf)
      ("fun" "Funktion" weiss--ahf)
      ("gb" "Gegenbeispiel" weiss--ahf)
      ("gz" "gleichzeitig" weiss--ahf)
      ("hs" "höchstens")
      ("ig" "insgesamt")
      ("ka" "keine Ahnung")
      ("kf" "kontextfrei" weiss--ahf)
      ("ls" "Lösung" weiss--ahf)
      ("ma" "Material" weiss--ahf)
      ("mg" "Möglichkeit" weiss--ahf)
      ("mi" "zumindest" weiss--ahf)
      ("nt" "natürlich" weiss--ahf)
      ("nm" "nochmal")
      ("nx" "nächst" weiss--ahf)
      ("pb" "Problem" weiss--ahf)
      ("pg" "Programmier" weiss--ahf)
      ("pj" "Project" weiss--ahf)
      ("rt" "Richtung" weiss--ahf)
      ("sl" "schlecht")
      ("sm" "Semester")
      ("st" "Schritt" weiss--ahf)
      ("ub" "Übung" weiss--ahf)
      ("ul" "unterschiedlich" weiss--ahf)
      ("vl" "Vorlesung" weiss--ahf)
      ("vllt" "vielleicht " weiss--ahf)
      ("wr" "während" weiss--ahf)
      ("zm" "zusammen" weiss--ahf)
      ("zf" "Zusammenfassung" weiss--ahf)
      ("mfg" "mit freundlichen Grüßen,\n" weiss--ahf)
      ("vdiv" "Vielen Dank im Voraus!\n" weiss--ahf)
;;;;; cycle number
      ("cn1" "①")
      ("cn2" "②")
      ("cn3" "③")
      ("cn4" "④")
      ("cn5" "⑤")
      )
    )
  )


(provide 'weiss_abbrevs_org)
