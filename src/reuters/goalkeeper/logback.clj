(ns reuters.goalkeeper.logback
  (:require [clojure.tools.logging :as log]
            [clojure.string :refer [lower-case trim]]
            [compojure.response :refer [render]])
  (:import (ch.qos.logback.classic Level LoggerContext)
            ch.qos.logback.classic.joran.JoranConfigurator
            ch.qos.logback.classic.util.ContextInitializer
            ch.qos.logback.core.util.StatusPrinter))

(defn- has-appender? [logger]
  (.. logger (iteratorForAppenders) (hasNext)))

(defn- get-defined-loggers* []
  (let [all_loggers (.. org.slf4j.LoggerFactory (getILoggerFactory) (getLoggerList))]
    (filter #(or (not (nil? (. %1 (getLevel)))) (has-appender? %1)) all_loggers)))

(defn- set-logger-level** [logger lvl]
  (let [orig-lvl-str (.. logger getLevel toString)]
    (.setLevel logger lvl)
    (str (.getName logger) ", " orig-lvl-str " --> " (.toString lvl))))

(defmulti set-logger-level* (fn [_ level] (trim (lower-case level))))
(defmethod set-logger-level* "debug" [logger _]
  (set-logger-level** logger Level/DEBUG))
(defmethod set-logger-level* "warn" [logger _]
  (set-logger-level** logger Level/WARN))
(defmethod set-logger-level* "info" [logger _]
  (set-logger-level** logger Level/INFO))
(defmethod set-logger-level* "error" [logger _]
  (set-logger-level** logger Level/ERROR))
(defmethod set-logger-level* "off" [logger _]
  (set-logger-level** logger Level/OFF))
(defmethod set-logger-level* "all" [logger _]
  (set-logger-level** logger Level/ALL))
(defmethod set-logger-level* :default [_ level]
  (str "Unknown log level: " level))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; url handlers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn list-loggers []
  (let [loggers (get-defined-loggers*)
        name-level-list (map #(list (. %1 (getName)) (.. %1 (getLevel) (toString))) loggers)]
    (render name-level-list nil)))

(defn set-logger-level [name level]
  (let [loggers (get-defined-loggers*)
        name-logger-map (reduce #(assoc %1 (.getName %2) %2) {} loggers)
        logger (name-logger-map name)]
    (if logger
      (set-logger-level* logger level)
      (str "No such defined logger: " name))))

(defn reload []
  (let [context (. org.slf4j.LoggerFactory (getILoggerFactory))
        ci (new ContextInitializer context)
        url (.. ci (findURLOfDefaultConfigurationFile true))
        configurator (new JoranConfigurator)]
    (log/debug "default logback conf file -->" (.toString url))
    (.. configurator (setContext context))
    (.reset context)
    (.. configurator (doConfigure url))
    (.. StatusPrinter (printInCaseOfErrorsOrWarnings context))
    (str "Successfully reloaded " (.toString url))))
