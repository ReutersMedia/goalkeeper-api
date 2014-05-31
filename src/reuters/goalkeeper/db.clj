(ns reuters.goalkeeper.db
  (:require [clojure.string :refer [join]]
            [korma.db :refer [defdb]]
            [korma.core :refer [exec-raw]]
            [clojure.tools.logging :as log]
            [reuters.goalkeeper.conf :refer [app-conf]]))

(defprotocol Comments 
  (insert [_ comment])
  (get-by-id [_ id])
  (get-by-parent-ids [_ get-status-fields ids deleted])
  (get-for-user [_ account-id from-date to-date limit])
  (get-all [_ deleted approved from-date to-date limit])
  (get-with-replies [this get-status-fields deleted comments])
  (count-all [_ deleted approved from-date to-date replies])
  (count-for-user [_ account-id from-date to-date replies])
  (approve [_ comment-id])
  (soft-delete-comment-and-its-replies [_ comment-id])
  (get-all-users [_])
  (get-user [_ id])
  (insert-or-update-user [_ user]))

(defn execute-raw-with-limit [db sql params limit]
  (if limit
    (exec-raw db [(str sql " LIMIT ?") (conj params limit)] :results) 
    (exec-raw db [sql params] :results)))

(defrecord CommentsDB [comments-db] Comments
  (insert [_ comment]
    (let [{:keys [parent-id url url-title user-id message tags approved]} comment
          sql (str "INSERT INTO COMMENTS (parent_id, url, url_title, message, tags, user_id, account_id, by_moderator, approved) "
                   "     SELECT ?, ?, ?, ?, ?, u.id, u.account_id, u.moderator, ?"
                   "       FROM COMMENTS_USERS u "
                   "      WHERE u.id = ?")]
          (exec-raw comments-db [sql [parent-id url url-title message tags approved user-id]])))

  (get-by-id [_ id]
    (let [sql (str "   SELECT c.id, c.url, c.url_title, u.name, u.email, u.account_name,"
                   "          c.by_moderator, c.timestamp, c.message, c.tags, c.approved, c.deleted "
                   "     FROM COMMENTS c "
                   "LEFT JOIN COMMENTS_USERS u ON u.id = c.user_id "
                   "    WHERE c.id = ?")]
      (first (exec-raw comments-db [sql [id]] :results))))

  (get-by-parent-ids [_ get-status-fields ids deleted]
    (if (not-empty ids)
      (let [in-clause (str "(" (join "," (take (count ids) (repeat "?"))) ")")
            select-status-fields (if get-status-fields ", c.approved, c.deleted " "")
            sql (str "   SELECT c.id, c.parent_id, c.url, c.url_title, u.name, u.email, u.account_name,"
                     "          c.by_moderator, c.timestamp, c.message, c.tags " select-status-fields
                     "     FROM COMMENTS c "
                     "LEFT JOIN COMMENTS_USERS u ON u.id = c.user_id "
                     "    WHERE c.parent_id in " in-clause " "
                     "      AND (c.deleted = ? OR ? is null) "
                     " ORDER BY c.timestamp, c.id ")]
        (exec-raw comments-db [sql (conj (vec ids) deleted deleted)] :results))
      []))

  (get-for-user [_ account-id from-date to-date limit]
    (let [sql (str " SELECT * FROM ("
                             "(  SELECT c.id, c.url, c.url_title, u.name, u.email, u.account_name,"
                             "          c.by_moderator, c.timestamp, c.message, c.tags "
                             "     FROM COMMENTS c "
                             "LEFT JOIN COMMENTS_USERS u ON u.id = c.user_id "
                             "    WHERE c.deleted = 0 "
                             "      AND c.account_id = ? "
                             "      AND (c.timestamp > ? OR ? is null) "
                             "      AND (c.timestamp < ? OR ? is null) "
                             "      AND c.parent_id is null "
                             " ORDER BY c.timestamp DESC "
                             "    LIMIT ?) "
                             "UNION ALL "
                             "(  SELECT c.id, c.url, c.url_title, u.name, u.email, u.account_name,"
                             "          c.by_moderator, c.timestamp, c.message, c.tags "
                             "     FROM COMMENTS c "
                             "LEFT JOIN COMMENTS_USERS u ON u.id = c.user_id "
                             "    WHERE c.deleted = 0 "
                             "      AND c.by_moderator = 1 "
                             "      AND c.account_id != ? "
                             "      AND (c.timestamp > ? OR ? is null) "
                             "      AND (c.timestamp < ? OR ? is null) "
                             "      AND c.parent_id is null "
                             " ORDER BY c.timestamp DESC "
                             "    LIMIT ?)) a "
                   " ORDER BY a.timestamp DESC, a.id DESC "
                   "    LIMIT ?" )
          params [account-id from-date from-date to-date to-date limit
                  account-id from-date from-date to-date to-date limit 
                  limit]]
      (exec-raw comments-db [sql params] :results)))

  (get-all [_ deleted approved from-date to-date limit]
    (let [sql (str "   SELECT c.id, c.url, c.url_title, u.name, u.email, u.account_name,"
                   "          c.by_moderator, c.timestamp, c.message, c.tags, c.approved, c.deleted "
                   "     FROM COMMENTS c "
                   "LEFT JOIN COMMENTS_USERS u ON u.id = c.user_id "
                   "    WHERE (c.deleted = ? OR ? is null) "
                   "      AND (c.approved = ? OR ? is null) "
                   "      AND (c.timestamp > ? OR ? is null) "
                   "      AND (c.timestamp < ? OR ? is null) "
                   "      AND c.parent_id is null "
                   " ORDER BY c.timestamp DESC ")
          params [deleted deleted approved approved from-date from-date to-date to-date]]
      (execute-raw-with-limit comments-db sql params limit)))

  (get-with-replies [this get-status-fields deleted comments]
    (when comments
      (let [ids (map :id comments)
            all-replies (get-by-parent-ids this get-status-fields ids deleted)
            replies-lookup (group-by :parent_id all-replies)]
        (map (fn [comment]
               (if-let [replies (replies-lookup (comment :id))]
                 (assoc comment :replies (map #(dissoc % :parent_id) replies))
                 (assoc comment :replies [])))
             comments))))

  (count-all [_ deleted approved from-date to-date replies]
    (let [sql (str "SELECT COUNT(*) as count"
                   "  FROM COMMENTS c "
                   " WHERE (c.deleted = ? OR ? is null) "
                   "   AND (c.approved = ? OR ? is null) "
                   "   AND (c.timestamp > ? OR ? is null) "
                   "   AND (c.timestamp < ? OR ? is null) "
                   "   AND (? OR c.parent_id is null)")
          result (exec-raw comments-db 
                           [sql [deleted deleted approved approved from-date from-date to-date to-date replies]] 
                           :results)]
      (first result)))

  (count-for-user [_ account-id from-date to-date replies]
    (let [sql (str "SELECT SUM(count) as count FROM "
                   "(  SELECT COUNT(*) as count "
                   "     FROM COMMENTS c "
                   "    WHERE c.deleted = 0 "
                   "      AND c.account_id = ? "
                   "      AND (c.timestamp > ? OR ? is null) "
                   "      AND (c.timestamp < ? OR ? is null) "
                   "      AND (? OR c.parent_id is null) "
                   "UNION ALL "
                   "   SELECT COUNT(*) as count"
                   "     FROM COMMENTS c "
                   "    WHERE c.deleted = 0 "
                   "      AND c.by_moderator = 1 "
                   "      AND c.account_id != ? "
                   "      AND (c.timestamp > ? OR ? is null) "
                   "      AND (c.timestamp < ? OR ? is null) "
                   "      AND (? OR c.parent_id is null)) s")
          result (exec-raw comments-db [sql [account-id from-date from-date to-date to-date replies 
                                             account-id from-date from-date to-date to-date replies]] :results)]
      (first result)))

  (approve [_ id]
    (let [sql (str "UPDATE COMMENTS "
                   "   SET approved = 1 "
                   " WHERE id = ?")]
      (exec-raw comments-db [sql [id]])))

  (soft-delete-comment-and-its-replies [_ id]
    (let [sql (str "UPDATE COMMENTS "
                   "   SET deleted = 1 "
                   " WHERE id = ? OR parent_id = ?")]
      (exec-raw comments-db [sql [id id]])))

  (get-all-users [_]
    (let [sql (str "SELECT * "
                   "  FROM COMMENTS_USERS")]
      (exec-raw comments-db [sql] :results)))

  (get-user [_ id]
    (let [sql (str "SELECT * "
                   "  FROM COMMENTS_USERS"
                   " WHERE id = ?")]
      (first (exec-raw comments-db [sql [id]] :results))))

  (insert-or-update-user [_ user]
    (let [{:keys [id name email moderator sanctioned account-name account-id last-update]} user
          sql (str "     INSERT INTO COMMENTS_USERS (id, name, email, moderator, sanctioned, account_name, " 
                   "                                 account_id, last_update) "
                   "          VALUES (?, ?, ?, ?, ?, ?, ?, ?) "
                   "ON DUPLICATE KEY UPDATE name = VALUES(name), email = VALUES(email), "
                   "                        moderator = VALUES(moderator), sanctioned = VALUES(sanctioned), "
                   "                        account_name = VALUES(account_name), account_id = VALUES(account_id), "
                   "                        last_update = VALUES(last_update)")]
          (exec-raw comments-db [sql [id name email moderator sanctioned account-name account-id last-update]]))))

(defdb comments (:comments_db app-conf))
(def comments-db (->CommentsDB comments))