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
            [reuters.goalkeeper.users-service :as users-service]
            [reuters.goalkeeper.logback :as logback]))

(def shutting-down? (atom false))

(defroutes app-routes
  ; welcome page 
  (GET "/" [] "Welcome to Reuters Goalkeeper API")

  (GET "/goalkeeper/:id" [id]
    (when-let [comment (db/get-by-id db/goalkeeper-db id)] 
       (->> comment
            vector
            (db/get-with-replies db/goalkeeper-db true 0 ,,,)
            first
            response)))

  (POST "/goalkeeper" [message url tags :as {{user-id :user_id url-title :url_title} :params}]
    (db/insert db/comments-db { :url url 
                                :url-title url-title 
                                :user-id user-id 
                                :message message
                                :approved 0 
                                :tags tags })
    (response (str "comment: " url ", " message " - was saved.")))

  (POST "/goalkeeper/:comment-id/approve" [comment-id]
    (db/approve db/comments-db comment-id)
    (response (str "comment: " comment-id " was approved.")))

  (POST "/goalkeeper/:comment-id/delete" [comment-id]
      (db/soft-delete-comment-and-its-replies db/comments-db comment-id)
      (response (str "comment: " comment-id " was deleted.")))

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
        (json/wrap-json-response)))

(defn init []
  (users-service/init))

(defn destroy [server]
  (users-service/destroy)
  (.stop server))

(defn -main [& args]
  (users-service/init)
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