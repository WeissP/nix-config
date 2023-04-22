(use '[clojure.java.shell :only [sh]])

(def ip-reg #"192\.168\.[0-9]\.[0-9]{0,3}")
(def device-name "R1-von-Weiss")


(defn find-device-by-name
  [name output]
  (some->> output
           (clojure.string/split-lines)
           (filter #(clojure.string/includes? % name))
           first
           (re-find ip-reg)))

(defn connect [ip] (sh "adb" "connect" ip))

(some->> (sh "nmap" "sn" "192.168.8.0/24" :dir "/home/weiss/")
         :out
         (find-device-by-name device-name)
         connect)

