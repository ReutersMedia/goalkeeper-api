(ns reuters.goalkeeper.middleware
  (:require [clojure.tools.logging :as log]
            [clojure.string :as str]
            [compojure.response :refer [render]]
            [ring.util.response :refer [response header]]
            [reuters.goalkeeper.utils :as utils]
            [reuters.goalkeeper.users-service :as users-service]))

(def ^:private get-user-id 
  ((fn []
    (let [user-regex (re-pattern "&?user_id=([^&]+)")]
      (fn [request]
        (when-let [user-id (last (re-find user-regex (or (:query-string request) "")))]
          (Integer/parseInt user-id)))))))

(def ^:private contains-all-users-param 
  ((fn []
    (let [all-users-regex (re-pattern "&?all_users=([^&]+)")]
      (fn [request]
        (last (re-find all-users-regex (or (:query-string request) ""))))))))

(defn- get-user [request]
  (-> request 
      get-user-id
      users-service/get-user))

(defn- replace-user-id-param [request user-id]
  (assoc request :query-string (str/replace (:query-string request) #"user_id=[^&]+" (str "user_id=" user-id))))

(defn- append-user-id-param [request user-id]
  (let [query-string (:query-string request)]
    (assoc request :query-string (str (if query-string (str query-string "&") "") "user_id=" user-id))))

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

(defn set-user-id-from-header [handler]
  (fn [request]
    (let [header-id (get-in request [:headers "remote-user"])
          param-id (get-user-id request)]
      (cond
        (and header-id param-id (not= header-id param-id)) (handler (replace-user-id-param request header-id))
        (and header-id (nil? param-id)) (handler (append-user-id-param request header-id))
        :else (handler request)))))

(defn check-permissions [handler]
  (let [validate-moderator (fn [user]
                             (when-not (users-service/moderator? user) 
                               "You must be moderator to perform this operation"))
        validate-not-sanctioned (fn [user]
                                  (when (users-service/sanctioned? user) 
                                    "You cannot perform this operation"))
        permissions { :get { 
                             (re-pattern "/debug/.*") (fn [request user]
                                                        (when-not (utils/local-address? (:remote-addr request))
                                                           "You only access this path locally"))
                             (re-pattern "/comments$") (fn [request user]
                                                         (if user
                                                           (or (validate-not-sanctioned user)
                                                               (and (contains-all-users-param request) 
                                                                    (validate-moderator user)))
                                                           "An existing user id must be passed"))
                             (re-pattern "/comments/\\d+$") (fn [request user]
                                                              (if user
                                                                (or (validate-not-sanctioned user)
                                                                    (validate-moderator user)) 
                                                                "An existing user id must be passed"))
                           }
                      :post { 
                              (re-pattern "/comments/\\d+/.+$") (fn [request user]
                                                                  (if user
                                                                    (or (validate-not-sanctioned user)
                                                                        (validate-moderator user)) 
                                                                    "An existing user id must be passed"))
                            } }]
    (fn [request]
      (let [user (get-user request)
            uri (:uri request)
            method-permissions ((:request-method request) permissions)
            permission-key (utils/find-first #(re-find % uri) (keys method-permissions))
            permission (if permission-key (method-permissions permission-key) (fn [request user]))]
        (if-let [error-msg (permission request user)]
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