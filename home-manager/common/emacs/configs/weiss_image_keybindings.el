(setq image-use-external-converter t)

(with-eval-after-load 'image
  (wks-define-key
   image-mode-map
   ""
   '(
     ("+" . image-increase-size)
     ("-" . image-decrease-size)
     ("." . image-next-line)
     ("," . image-previous-line)
     ))
  )

(provide 'weiss_image_keybindings)
