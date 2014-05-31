(ns reuters.goalkeeper.utils
  (:require [clojure.string :as str]
            [clojure.tools.logging :as log]
            [clj-http.client :as http-client]))

(defn- get-host-addresses []
  (->> (java.net.NetworkInterface/getNetworkInterfaces)
       enumeration-seq
       (mapcat #(.. % (getInterfaceAddresses)))
       (map #(.. % (getAddress) (getHostAddress)))))

(def local-address? 
  (let [local-addresses (conj (set (get-host-addresses))
                              "localhost" "127.0.0.1")]
    (fn [addr] (local-addresses addr))))

(defn get-json [url] 
  (:body (http-client/get url 
                          { :conn-timeout 10000 ;in milliseconds
                            :accept :json 
                            :as :json })))

(def not-nil? (complement nil?))

(defn find-first [f coll]
  (first (filter f coll)))

(def select-values 
  (comp vals select-keys))

(defn seq-of-maps-to-lookup [seq-of-maps key]
  (into {} (map (fn [item] [(item key) item]) seq-of-maps)))

(def hyphenize-keywords 
  ((fn [] 
    (let [underscore-regex (re-pattern "_")]
      (fn [input-map]
        (let [underscore-keys-as-strings (filter #(re-find underscore-regex %) (map name (keys input-map)))]
          (if (not-empty underscore-keys-as-strings)
            (let [underscore-keys (map keyword underscore-keys-as-strings)
                  hyphened-keys (map #(keyword (str/replace % underscore-regex "-")) underscore-keys-as-strings)
                  underscore-values (reverse (select-values input-map underscore-keys))]
                  (merge (apply dissoc (conj underscore-keys input-map)) (zipmap hyphened-keys underscore-values)))
            input-map)))))))