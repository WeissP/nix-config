(with-eval-after-load 'string-inflection
  (defun string-inflection-rust-style-cycle-function (str)
    "fooBar => FOO_BAR => FooBar => fooBar"
    (cond
     ((string-inflection-underscore-p str)
      (string-inflection-pascal-case-function str))
     (t
      (string-inflection-underscore-function str))))

  (defun string-inflection-rust-style-cycle ()
    "fooBar => FOO_BAR => FooBar => fooBar"
    (interactive)
    (string-inflection-insert
     (string-inflection-rust-style-cycle-function (string-inflection-get-current-word))))

  (defun weiss-string-inflection-cycle-auto ()
    "switching by major-mode"
    (interactive)
    (cond
     ((eq major-mode 'rustic-mode)
      (string-inflection-rust-style-cycle))     
     (t
      (string-inflection-all-cycle))))
  )

(provide 'weiss_string-inflection_settings)
