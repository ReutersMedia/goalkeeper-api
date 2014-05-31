(ns reuters.goalkeeper.users-service
  (:require [clojure.tools.logging :as log]
            [schejulure.core :refer :all]
            [reuters.goalkeeper.users-cache :as users-cache]
            [reuters.goalkeeper.gpdb :as gpdb]
            [reuters.goalkeeper.utils :as utils]
            [reuters.goalkeeper.conf :refer [app-conf]]))

(def ^:private users-timestamps (atom {}))
(def ^:private moderator-role-id (atom nil))
(def ^:private sanctioned-role-id (atom nil))
(def ^:private sync-scheduler (atom nil)) 

(defn- has-role? [gpdb-user role-id]
  (utils/not-nil? (utils/find-first #(= % role-id) (:roles gpdb-user))))

(defn- gpdb-user-to-comments-user [gpdb-user]
  { :post [(or (nil? %) (> (:last-update %) 0))] } ; make sure the user is in the timestamps
  (when-let [user (get-in gpdb-user [:agencyUser :user])]
    (assoc (select-keys user [:id :email]) :name (str (:firstName user) " " (:lastName user))
                                           :account-id (:accountId user) 
                                           :account-name (:accountName user)
                                           :moderator (has-role? user @moderator-role-id)
                                           :sanctioned (has-role? user @sanctioned-role-id)
                                           :last-update (@users-timestamps (:id user)))))

(defn- get-user-from-gpdb [id]
  (-> id
      gpdb/get-user
      gpdb-user-to-comments-user))

(defn- get-and-cache-gpdb-user [id]
  (when-let [user (get-user-from-gpdb id)]
    (users-cache/put-user user)))

(defn- load-users-timestamps []
  (let [start (.getTime (java.util.Date.))]
    (reset! users-timestamps (gpdb/get-users-timestamps-map))
    (log/info (str "loading timestamps took " (- (.getTime (java.util.Date.)) start)))))

(defn moderator? [user]
  (:moderator user))

(defn sanctioned? [user]
  (:sanctioned user))

(defn show-user-timestamps [] @users-timestamps)

(defn get-user [id]
  (when id
    (if-let [user (users-cache/get-user id)]
      user
      (get-and-cache-gpdb-user id))))

(defn sync-users []
  (log/info (str "synching users to gpdb"))
  (load-users-timestamps)
  (let [users (users-cache/get-all-users)]
    (doseq [user users]
      (if-let [last-update (@users-timestamps (:id user))]
        (when (> last-update (:last-update user))
          (get-and-cache-gpdb-user (:id user)))
        (log/warn (str "user with id: " (:id user) " did not have gpdb timestamp"))))))

(defn init []
  (users-cache/init :id)
  (reset! moderator-role-id (gpdb/get-moderator-role-id))
  (reset! sanctioned-role-id (gpdb/get-sanctioned-role-id))
  (sync-users)
  (reset! sync-scheduler (schedule {:minute (range 0 60 5)} sync-users))) ;refresh users every 5 minutes

(defn destroy []
  (future-cancel @sync-scheduler)
  (. pool shutdown))