(with-eval-after-load 'ligature 
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes

  (let ((prog-ligatures '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                          ":::" "::=" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                          "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "-<<"
                          "<~~" "<~>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                          "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                          "..." "+++" "/==" "_|_" "www" "&&" "^=" "~~" "~="
                          "~>" "~-" "**" "<*" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                          "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                          ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<|" "<:"
                          "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                          "##" "#?" "#_" "%%" ".-" ".." ".?" "+>" "++" "?:"
                          "?=" "?." "??" ";;" "/*" "/>" "__" "~~" 
                          "://" "===" "=!=" "???" ":<|>" "<*>" "/=" )
                        )
        (text-ligatures '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                          ":::" "::=" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                          "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "-<<"
                          "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                          "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                          "..." "+++" "/==" "_|_" "www" "&&" "^=" "~~" "~="
                          "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                          "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                          ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                          "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                          "##" "#?" "#_" "%%" ".-" ".." ".?" "+>" "++" "?:"
                          "?=" "?." "??" ";;" "/*" "/>" "__" "~~" "(*" "*)" 
                          "://"))
        )
    (ligature-set-ligatures 'prog-mode prog-ligatures)    
    (with-eval-after-load 'comint
      (ligature-set-ligatures 'comint-mode prog-ligatures)
      )
    
    (ligature-set-ligatures 'sgml-mode text-ligatures)    
    (ligature-set-ligatures 'org-mode text-ligatures)    
    )  
  (global-ligature-mode t)
  )

;; parent: 
(provide 'weiss_ligature_settings)
