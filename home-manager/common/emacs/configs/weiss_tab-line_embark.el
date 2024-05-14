(with-eval-after-load 'tab-line
  (defvar-keymap weiss-embark-tab-group-actions
    :doc "Keymap for actions for tab group"
    "d" #'weiss-file-groups-delete
    )

  (with-eval-after-load 'embark
    (add-to-list 'embark-keymap-alist '(tab-group . weiss-embark-tab-group-actions))
    )
  )

(provide 'weiss_tab-line_embark)
