
;; Don't use different background for tabs.
;; (face-spec-set 'whitespace-tab
;; '((t :background unspecified)))
;; Only use background and underline for long lines, so we can still have
;; syntax highlight.

;; For some reason use face-defface-spec as spec-type doesn't work.  My guess
;; is it's due to the variables with the same name as the faces in
;; whitespace.el.  Anyway, we have to manually set some attribute to
;; unspecified here.
;; (face-spec-set 'whitespace-line
;;                '((((background light))
;;                   :background "#d8d8d8" :foreground unspecified
;;                   :underline t :weight unspecified)
;;                  (t
;;                   :background "#404040" :foreground unspecified
;;                   :underline t :weight unspecified)))

;; Use softer visual cue for space before tabs.
;; (face-spec-set 'whitespace-space-before-tab
;;                '((((background light))
;;                   :background "#d8d8d8" :foreground "#de4da1")
;;                  (t
;;                   :inherit warning
;;                   :background "#404040" :foreground "#ee6aa7")))

(setq
 whitespace-line-column nil
 )


;; parent: ui
(provide 'weiss_whitespace_settings)
