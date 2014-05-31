(defproject goalkeeper-api "1.0.0"
  :description "Goalkeeper betting app and API`"
  :main reuters.comments.core
  :dependencies [[org.clojure/clojure "1.5.1"]
                 [org.clojure/tools.logging "0.2.6"]
                 [org.slf4j/slf4j-api "1.7.2"]
                 [org.slf4j/log4j-over-slf4j "1.7.6"]
                 [ch.qos.logback/logback-classic "1.0.9"]
                 [korma "0.3.0-RC7"]
                 [org.clojure/java.jdbc "0.3.3"]
                 [mysql/mysql-connector-java "5.1.24"]
                 [compojure "1.1.6"]
                 [clj-http "0.9.1"]
                 [schejulure "0.1.4"]
                 [ring/ring-core "1.2.2"]
                 [ring/ring-json "0.3.0"]
                 [ring/ring-jetty-adapter "1.2.2"]]
  :plugins [[lein-ring "0.8.10"]
            [lein-pprint "1.1.1"]
            [lein-libdir "0.1.1"]]
  :ring {:handler reuters.comments.core/app 
         :init reuters.comments.core/init
         :port 30000}
  :profiles {:dev {:dependencies [[ring-mock "0.1.3"]]}})