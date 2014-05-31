(ns reuters.goalkeeper.conf)

(def app-root
  (if-let [root (System/getProperty "APP_HOME")]
    root
    "./"))

(def load-conf (comp read-string slurp))

(def app-conf
  (load-conf (str app-root "/conf/app.conf")))