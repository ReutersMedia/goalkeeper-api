(ns reuters.goalkeeper.middleware
  (:require [clojure.tools.logging :as log]
            [clojure.string :as str]
            [compojure.response :refer [render]]
            [ring.util.response :refer [response header]]
            [reuters.goalkeeper.utils :as utils]
            [reuters.goalkeeper.users-service :as users-service]))

(defn log-access [handler]
  (let [access-log-helper (fn [level & args]
                            (try (log/log "access" level nil (apply print-str args))
                              (catch Throwable t (println "log error" (.getMessage t)))))]
    (fn [request]
      (let [remote-addr (:remote-addr request)
            scheme (name (:scheme request))
            method (name (:request-method request))
            uri (:uri request)
            qs (or (:query-string request) "-")]
        (access-log-helper :debug "[request2]" remote-addr scheme method uri qs)
        (let [res (handler request)
              sts (:status res)]
          (access-log-helper :info "[response]" remote-addr scheme method uri qs sts)
          res)))))

(defn check-permissions [handler]
  (let [permissions { :get { 
                             (re-pattern "/debug/.*") (fn [request]
                                                        (when-not (utils/local-address? (:remote-addr request))
                                                           "You only access this path locally"))
                           }
                    }]
    (fn [request]
      (let [uri (:uri request)
            method-permissions ((:request-method request) permissions)
            permission-key (utils/find-first #(re-find % uri) (keys method-permissions))
            permission (if permission-key (method-permissions permission-key) (fn [request]))]
        (if-let [error-msg (permission request)]
          { :status 403 :body error-msg }
          (handler request))))))

(defn wrap-errors [handler]
  (fn [request]
    (try
      (handler request)
      (catch Throwable t
        (log/error t "Unhandled Exception")
        { :status 500
          :body (str "An error occured: " (.getMessage t))}))))

(defn no-cache [handler]
  (fn [request]
    (let [response (handler request)]
      (header response "Cache-Control" "max-age=0"))))