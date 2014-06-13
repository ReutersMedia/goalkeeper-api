(ns reuters.goalkeeper.core
  (:use [compojure.core :only (defroutes GET POST context)]
        [compojure.route :only (not-found)]
        [ring.util.response :only (response)]
        [ring.adapter.jetty :only (run-jetty)])
  (:require [compojure.handler :as handler]
            [clojure.java.io :as io]
            [clojure.tools.logging :as log]
            [ring.middleware.json :as json]
            [reuters.goalkeeper.conf :as conf]
            [reuters.goalkeeper.middleware :as mw]
            [reuters.goalkeeper.db :as db]
            [reuters.goalkeeper.logback :as logback]))

(def shutting-down? (atom false))

(defroutes app-routes
  ; welcome page 
  (GET "/" [] "Welcome to Reuters Goalkeeper API")

  (GET "/goalkeeper/users/:user-id/games" [user-id from to]
    (let [user-id (Long/parseLong user-id)
          from (.parse (java.text.SimpleDateFormat. "yyyy-MM-dd HH:mm:ssZ") from)
          to (.parse (java.text.SimpleDateFormat. "yyyy-MM-dd HH:mm:ssZ") to)]
    (response (db/get-user-games db/goalkeeper-db user-id from to))))

  (POST "/goalkeeper/users/:user-id/games/:game-id" [user-id game-id prediction]
    (let [user-id (Long/parseLong user-id)
          game-id (Integer/parseInt game-id)]
      (db/update-user-prediction db/goalkeeper-db user-id game-id prediction)
      (response (str "user: " user-id " prediction for game: " game-id " - was saved"))))

  (GET "/goalkeeper/users/:user-id" [user-id]
    (when-let [user (db/get-user-by-id db/goalkeeper-db (Long/parseLong user-id))] 
      (response user)))

  (POST "/goalkeeper/users/:user-id" [user-id first last country player level :as {{ picture-url :picture_url} :params}]
    (db/insert-or-update-user db/goalkeeper-db { :id (Long/parseLong user-id)
                                                 :first first
                                                 :last last
                                                 :picture-url picture-url
                                                 :country country
                                                 :player player
                                                 :level (Integer/parseInt level)})
    (response (str "user: " user-id ", " first " " last " - was saved.")))

  (GET "/goalkeeper/users" [from to limit]
    (let [from (.parse (java.text.SimpleDateFormat. "yyyy-MM-dd HH:mm:ssZ") from)
          to (.parse (java.text.SimpleDateFormat. "yyyy-MM-dd HH:mm:ssZ") to)]
      (response (db/get-top-predictors db/goalkeeper-db from to (Integer/parseInt limit)))))

  ; keepalive for nagios check
  (GET "/keepalive" [] (if @shutting-down? nil "alive"))

  ; logback setting
  (context "/debug/logback" []
      (GET "/list_loggers" [] (logback/list-loggers))
      (GET "/set_logger_level/:name/:level" [name level] (logback/set-logger-level name level))
      (GET "/reload_conf" [] (logback/reload)))

  ; all others are 404
  (not-found "Page Not Found!"))

(def app 
    (-> (handler/api app-routes)
        (mw/check-permissions)
        (mw/log-access)
        (mw/wrap-errors)
        (mw/no-cache)
        (mw/cors)
        (json/wrap-json-response)))

(defn init [])

(defn destroy [server]
  (.stop server))

(defn -main [& args]
  (let [stop-file (io/file conf/app-root "app.stop")
        server (run-jetty #'app { :port (get-in conf/app-conf [:jetty :port])
                                  :max-threads (get-in conf/app-conf [:jetty :threads])
                                  :join? false})]
    (log/info "Goalkeeper API Started ... ")
    (log/debug "Stop file:" (.getAbsolutePath stop-file))
    (while (not (.exists stop-file)) (Thread/sleep 1000))
    (swap! shutting-down? (fn [_] true)); set shutting-down? to true and sleep 10 seconds so that
                                        ; keepalive returns 404 and LB knows this server is out-of-service.
    (Thread/sleep 10000)
    (log/info "Found stop file:" (.getAbsolutePath stop-file) " stop.")
    (destroy server)
    nil))