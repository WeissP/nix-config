(defun weiss-gen-one-of (chars)
  "Based on https://stackoverflow.com/questions/37038441/generate-a-random-5-letternumber-string-at-cursor-point-all-lower-case"
  (let* ((i (% (abs (random)) (length chars))))
    (substring chars i (1+ i))))

(defun weiss-gen-password ()
  "Generate a password in format xxxx-xxxx-XXXX-nnnn, where:
     x: lowercase a-z
     X: uppercase A-Z
     n: digit 0-9"
  (interactive)
  (let* ((lowercase "abcdefghijklmnopqrstuvwxyz")
         (uppercase "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
         (digits "0123456789")
         (part1 (concat (weiss-gen-one-of lowercase)
                        (weiss-gen-one-of lowercase)
                        (weiss-gen-one-of lowercase)
                        (weiss-gen-one-of lowercase)))
         (part2 (concat (weiss-gen-one-of lowercase)
                        (weiss-gen-one-of lowercase)
                        (weiss-gen-one-of lowercase)
                        (weiss-gen-one-of lowercase)))
         (part3 (concat (weiss-gen-one-of uppercase)
                        (weiss-gen-one-of uppercase)
                        (weiss-gen-one-of uppercase)
                        (weiss-gen-one-of uppercase)))
         (part4 (concat (weiss-gen-one-of digits)
                        (weiss-gen-one-of digits)
                        (weiss-gen-one-of digits)
                        (weiss-gen-one-of digits))))
    (concat part1 "-" part2 "-" part3 "-" part4)))

(defun weiss-pass-normalize-url (beg end)
  "DOCSTRING"
  (interactive "@r")
  (thread-first
    (delete-and-extract-region beg end)
    (string-trim-left "http.?://")
    (string-trim-right "/.*")
    ((lambda (x) (format "url: *%s/*" x)))
    (insert)))

(defun weiss-pass-gen-info ()
  "DOCSTRING"
  (interactive)
  (insert (format "%s\nusername: \nautotype: username :tab pass" (weiss-gen-password)))
  (search-backward "username:")
  (forward-char 10)
  )

(provide 'weiss_pass_settings)

