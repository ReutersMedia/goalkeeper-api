(ns reuters.goalkeeper.users-db-cache
  (:require [clojure.tools.logging :as log]
            [reuters.goalkeeper.db :as db]
            [reuters.goalkeeper.utils :as utils]))

(defn- convert-to-clojure [user]
  (utils/hyphenize-keywords user))

(defn get-all []
  (if-let [users (db/get-all-users db/comments-db)]
    (map convert-to-clojure users)
    []))

(defn get-user [id]
  (when-let [user (db/get-user db/comments-db id)]
    (convert-to-clojure user)))

(defn put-user [user]
  (db/insert-or-update-user db/comments-db user))