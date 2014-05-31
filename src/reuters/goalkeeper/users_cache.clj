(ns reuters.goalkeeper.users-cache
  (:require [clojure.tools.logging :as log]
            [reuters.goalkeeper.users-db-cache :as db-cache]))

(def ^:private id-key (atom nil))
(def ^:private users-cache (atom {}))

(defn- put-in-memory-only [user]
  (swap! users-cache assoc (user @id-key) user))

(defn- sync-users []
  (doseq [user (db-cache/get-all)]
    (put-in-memory-only user)))

(defn get-user [id]
  (if-let [user (@users-cache id)]
    user
    (when-let [user (db-cache/get-user id)]
      (put-in-memory-only user)
      user)))

(defn get-all-users []
  (sync-users)
  (vals @users-cache))

(defn show-cache [] @users-cache)

(defn put-user [user]
  (put-in-memory-only user)
  (db-cache/put-user user)
  user)

(defn init [id-keyword]
  (reset! id-key id-keyword)
  (sync-users))