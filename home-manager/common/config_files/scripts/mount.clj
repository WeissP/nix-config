(use '[clojure.java.shell :only [sh]])

;; (def *command-line-args* '("m" "none" "as"))

(def default-device-uuid "0454a6cf-a298-4f74-8873-0af259524f6f")
(def default-options "compress=zstd")

(defn get-cmd
  [cmd]
  (case cmd
    ("m" "mount") "mount"
    ("u" "unmount") "unmount"))

(def cmd
  (if (> (count *command-line-args*) 0)
    (get-cmd (first *command-line-args*))
    "mount"))

(def device-uuid
  (if (> (count *command-line-args*) 2)
    (nth *command-line-args* 2)
    default-device-uuid))

(def options
  (if (> (count *command-line-args*) 1)
    (let [opt (nth *command-line-args* 1)] (when-not (= opt "none") opt))
    (if (= device-uuid default-device-uuid) default-options nil)))

(defn find-device
  [lines]
  (let [p (fn [line] (clojure.string/includes? line device-uuid))]
    (first (filter p lines))))

(defn index [i line] (nth (clojure.string/split line #" +") i))

(defn check
  [lines]
  (if (< (count lines) 1)
    (throw (Exception. (str "can not find device: " device-uuid)))
    lines))

(defn get-location
  []
  (->> (sh "lsblk" "--output" "UUID,NAME" "--list")
       :out
       clojure.string/split-lines
       find-device
       check
       (index 1)
       (str "/dev/")))

(let [default ["udisksctl" cmd "-b" (get-location)]
      res (apply sh
            (if (and options (= cmd "mount"))
              (conj default "-o" options)
              default))]
  (if (not= (:err res) "") (println (:err res)) (println (:out res))))





