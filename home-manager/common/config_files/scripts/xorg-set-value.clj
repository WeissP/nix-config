(use '[clojure.java.shell :only [sh]])

(def key-repeat-value '("230" "30"))
(def keyboard-layout '("de"))

(defn get-sublist-by-index
  [l indices-set]
  (keep-indexed (fn [index item] (when (indices-set index) item)) l))

(defn key-repeat-resetted?
  []
  (let [output (:out (sh "xset" "-q"))
        matcher (re-find #"auto repeat delay:\s+(\d+)\s+repeat rate:\s+(\d+)"
                         output)
        values (get-sublist-by-index matcher #{1 2})]
    (not (= values key-repeat-value))))
(defn keyboard-layout-resetted?
  []
  (let [output (:out (sh "setxkbmap" "-query"))
        matcher (re-find #"layout:\s*([a-z]+)" output)
        values (get-sublist-by-index matcher #{1})]
    (not (= values keyboard-layout))))

;; (when (key-repeat-resetted?) (apply sh "xset" "r" "rate" key-repeat-value))
;; (when (keyboard-layout-resetted?) (apply sh "setxkbmap" keyboard-layout))
;; crontab can only run task every minute, so this script will run 19 time
;; every
;; 3 seconds(totally 57 seconds)
(dotimes [n 19]
  ;; (println "start")
  (when (key-repeat-resetted?) (apply sh "xset" "r" "rate" key-repeat-value))
  (when (keyboard-layout-resetted?) (apply sh "setxkbmap" keyboard-layout))
  (Thread/sleep 3000)
  ;; (println "end")
)


