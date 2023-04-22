;; (use '[clojure.java.shell :only [sh]])
(require '[clojure.java.io :as io])
(require '[babashka.process :refer [shell sh process check]])
;; (def *command-line-args* '("." "/home"))

;; (def extension ".webm")

(defn get-dir
  []
  (let [d (or (first *command-line-args*) ".")]
    (if (clojure.string/ends-with? d "/") d (str d "/"))))

(defn list-files-with-extension
  ([dir extension]
   (filter #(clojure.string/ends-with? % extension) (.list (io/file dir)))))

(defn replace-extension
  [dir filename in-extension out-extension]
  (str dir
       (clojure.string/replace filename
                               (re-pattern (str in-extension "$"))
                               out-extension)))


(defn convert-video
  [in-path out-path]
  (println "Start converting" in-path)
  (shell "ffmpeg" "-i" in-path out-path)
  (println "---------------------------------"))


(defn convert-batch
  [dir in-extension out-extension]
  (doseq [video (list-files-with-extension dir in-extension)]
    (let [in-path (str dir video)
          out-path (replace-extension dir video in-extension out-extension)]
      (convert-video in-path out-path))))

(convert-batch (get-dir) ".webm" ".mp4")
(convert-batch (get-dir) ".m4v" ".mp4")
(convert-batch (get-dir) ".mov" ".mp4")
(convert-batch (get-dir) ".MOV" ".mp4")

;; (defn get-location
;;   []
;;   (->> (sh "/usr/bin/lsblk" "--output" "UUID,NAME" "--list")
;;        :out
;;        clojure.string/split-lines
;;        find-device
;;        check
;;        (index 1)
;;        (str "/dev/")))

;; (let [default ["/usr/bin/udisksctl" cmd "-b" (get-location)]
;;       res (apply sh
;;             (if (and options (= cmd "mount"))
;;               (conj default "-o" options)
;;               default))]
;;   (if (not= (:err res) "") (println (:err res)) (println (:out res))))





