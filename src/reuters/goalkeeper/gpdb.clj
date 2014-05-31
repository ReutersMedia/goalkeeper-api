(ns reuters.goalkeeper.gpdb
  (:require [clojure.tools.logging :as log]
            [reuters.goalkeeper.utils :as utils]
            [reuters.goalkeeper.conf :refer [app-conf]]))

(defn get-user [id]
  (utils/get-json (str (get-in app-conf [:gpdb_ws :url]) "/gpdb-webservices/agency/getAgencyUser?userId=" id)))

(def get-roles 
  ((fn [] 
    (let [gpdb-url (str (get-in app-conf [:gpdb_ws :url]) "/gpdb-webservices/agency/getUserRoleTypes")]
      (fn []
        (:userRoleTypeList (utils/get-json gpdb-url)))))))

(defn get-moderator-role-id [] 
  (:id (utils/find-first #(= (:exportedName %) "ROLE_MEXP_MODERATOR") (get-roles))))

(defn get-sanctioned-role-id [] 
  (:id (utils/find-first #(= (:exportedName %) "ROLE_SANCTIONED_USER") (get-roles))))

(def get-users-timestamps-map 
  ((fn [] 
    (let [gpdb-url (str (get-in app-conf [:gpdb_ws :url]) 
                         "/gpdb-webservices/agency/getUserTimestampMap?userTypeId=1")]
      (fn []
        (into {} (map (fn [{:keys [id bean]}] [id bean])
                      (:integerMapBeanList (utils/get-json gpdb-url)))))))))