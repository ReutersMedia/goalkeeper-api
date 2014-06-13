(ns reuters.goalkeeper.db
  (:require [clojure.string :refer [join]]
            [korma.db :refer [defdb]]
            [korma.core :refer [exec-raw]]
            [clojure.tools.logging :as log]
            [reuters.goalkeeper.conf :refer [app-conf]]))

(defprotocol IGoalKeeper 
  (get-user-games [_ user-id from to])
  (update-user-prediction [_ user-id game-id prediction])
  (get-user-by-id [_ user-id])
  (get-all-users-wo-excluded [_ exclude-users limit])
  (get-all-users [_ limit])
  (count-played-games [_ to-date])
  (get-top-predictors [this from to limit])
  (insert-or-update-user [_ user]))

(defn execute-raw-with-limit [db sql params limit]
  (if limit
    (exec-raw db [(str sql " LIMIT ?") (conj params limit)] :results) 
    (exec-raw db [sql params] :results)))

(defrecord GoalKeeperDB [db] IGoalKeeper
  (get-user-games [_ user-id from to]
    (let [sql (str "   SELECT pg.game_id as id, pg.start_date, pg.team0, pg.team1, pg.winner, pg.score, up.prediction "
                   "     FROM phase_games pg "
                   "LEFT JOIN users_predictions up on up.user_id = ? and up.game_id = pg.game_id "
                   "    WHERE pg.start_date >= ? AND pg.start_date <= ? "
                   " ORDER BY pg.start_date")]
      (exec-raw db [sql [user-id from to]] :results)))

  (update-user-prediction [_ user-id game-id prediction]
    (let [sql (str "     INSERT INTO users_predictions (user_id, game_id, prediction)" 
                   "          VALUES (?, ?, ?) "
                   "ON DUPLICATE KEY UPDATE user_id = VALUES(user_id), game_id = VALUES(game_id),"
                   "                        prediction = VALUES(prediction) ")]
          (exec-raw db [sql [user-id game-id prediction]])))

  (get-user-by-id [_ user-id]
    (let [sql (str "SELECT u.id, u.first, u.last, u.picture_url, u.country, u.player, u.level"
                   "  FROM users u "
                   " WHERE u.id = ?")]
      (first (exec-raw db [sql [user-id]] :results))))

  (get-all-users-wo-excluded [_ exclude-users limit]
    (let [in-clause (str "(" (join "," (take (count exclude-users) (repeat "?"))) ")")
          sql (str "  SELECT u.id, u.first, u.last, u.picture_url, u.country, u.player, u.level "
                   "    FROM users u "
                   "   WHERE u.id NOT IN " in-clause " "
                   "ORDER BY u.last,u.first")]
      (execute-raw-with-limit db sql exclude-users limit)))

  (get-all-users [_ limit]
    (let [sql (str "  SELECT u.id, u.first, u.last, u.picture_url, u.country, u.player, u.level "
                   "    FROM users u "
                   "ORDER BY u.last,u.first")]
      (execute-raw-with-limit db sql [] limit)))

  (count-played-games [_ to-date]
    (let [sql (str "    SELECT count(*) as count"
                   "      FROM phase_games pg "
                   "     WHERE pg.start_date < ? " 
                   "       AND pg.winner IS NOT NULL ")]
      (first (exec-raw db [sql [to-date]] :results))))

  (get-top-predictors [this from to limit]
    (let [games (:count (count-played-games this to))
          sql (str "    SELECT p.score, u.* "
                   "      FROM ( "
                   "                SELECT up.user_id as id,"
                   "                       cast(sum(if(pg.winner = up.prediction, 1, 0)) as unsigned) as score"
                   "                  FROM phase_games pg "
                   "            INNER JOIN users_predictions up on up.game_id = pg.game_id"
                   "                 WHERE pg.start_date < ? " 
                   "                   AND pg.winner IS NOT NULL "
                   "              GROUP BY up.user_id) p "
                   "INNER JOIN users u on u.id = p.id "
                   "  ORDER BY p.score DESC,u.last,u.first")
          top (execute-raw-with-limit db sql [from] limit)
          new-limit (- limit (count top))
          all (cond 
                (= 0 new-limit) top
                (= limit new-limit) (get-all-users this limit)
                :else (concat top (get-all-users-wo-excluded this (mapv :id top) new-limit)))]
      (mapv #(assoc % :games games 
                      :predictions (get-user-games this (:id %) from to)) 
            all)))

  (insert-or-update-user [_ user]
    (let [{:keys [id first last picture-url country player level]} user
          sql (str "     INSERT INTO users (id, first, last, picture_url, country, player, level)" 
                   "          VALUES (?, ?, ?, ?, ?, ?, ?) "
                   "ON DUPLICATE KEY UPDATE id = VALUES(id), first = VALUES(first), last = VALUES(last),"
                   "                        picture_url = VALUES(picture_url), country = VALUES(country), "
                   "                        player = VALUES(player), level = VALUES(level) ")]
          (exec-raw db [sql [id first last picture-url country player level]]))))

(defdb goalkeeper (:db app-conf))
(def goalkeeper-db (->GoalKeeperDB goalkeeper))