(require 'dired-single-handed-filter)

(defvar weiss-dired-single-handed-mode-map (make-sparse-keymap))

(defun weiss-extract-bangou (s)
  "DOCSTRING"
  (string-match "[a-zA-Z]\\{3,5\\}-?[0-9]\\{3\\}" s)
  (ignore-errors (match-string 0 s))
  )

(defun single-handed--play-video (file &optional subtitle-path)
  "DOCSTRING"
  (interactive)
  (start-process-shell-command
   "mpv" nil
   (format "mpv --start=0%% -title  \"%s\" -fs \"%s\" %s"
           (thread-last file
                        (file-name-nondirectory)
                        (file-name-sans-extension)
                        (s-replace "\"" "\"")
                        )
           file
           (if subtitle-path
               (format "-sub \"%s\"" subtitle-path)
             ""
             )
           )))

(defun weiss-single-hand-play-movie ()
  "DOCSTRING"
  (interactive)
  (let* ((file (car (dired-get-marked-files nil nil nil nil t)))
         (bangou (weiss-extract-bangou file))
         (subtitle-path (when bangou (format "%ssubtitles/%s.srt" (file-name-directory file) bangou)))
         )
    (message "subtitle-path: %s" subtitle-path)
    (single-handed--play-video file (when (ignore-errors (file-exists-p subtitle-path)) subtitle-path))))

;;;###autoload
(define-minor-mode weiss-dired-single-handed-mode
  "weiss-dired-single-handed-mode"
  :lighter " single-hand"
  :keymap weiss-dired-single-handed-mode-map
  :group 'weiss-dired-single-handed-mode
  (if weiss-dired-single-handed-mode
      (progn
        (set-face-background 'hl-line "#ffb5ff")
        (set-face-background 'normal-hl-line "#ffb5ff"))
    (set-face-background 'hl-line "#ffe8e8")
    (set-face-background 'normal-hl-line "#ffe8e8")))

(provide 'dired-single-handed-mode)
