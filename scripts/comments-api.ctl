#/bin/sh

if [ "`echo $USER`" != "__RUN_USER__" ]; then
  echo "Must run as __RUN_USER__!"
  exit 1
fi

NAME=comments-api
JAVA_HOME=/usr/java/default
APP_HOME="$(cd -L "$(dirname $0)" && pwd)"
PID_FILE=${APP_HOME}/${NAME}.pid
STOP_FILE=${APP_HOME}/app.stop
JETTY_PORT=`grep jetty_port ${APP_HOME}/conf/app.conf | sed "s/[^0-9]*//g"`

CLASSPATH=${APP_HOME}/resources
for f in `ls ${APP_HOME}/lib`; do
    CLASSPATH=$CLASSPATH:${APP_HOME}/lib/${f}
done
JAVA_OPTS="-server -Xms512M -Xmx1024M -XX:+TieredCompilation -DAPP_HOME=${APP_HOME}"
START_CMD="${JAVA_HOME}/bin/java ${JAVA_OPTS} -cp ${CLASSPATH} clojure.main -m reuters.comments.core"

ping_server() {
  status=`curl --max-time 5 --output /dev/null --silent --url "http://127.0.0.1:${JETTY_PORT}/keepalive" --write-out "%{http_code}"`
  if [ $? == 0 -a "$status" == "200" ]; then
    return 0 
  else 
    return 1
  fi
}

# returns 0 if PID in file is running, 1 if otherwise
pid_running() {
  pid=`cat "$PID_FILE" 2>/dev/null`
  if [ "$pid" == "" ]; then
    return 1 # PID file does not exist
  else
    kill_report=`kill -0 $pid 2>&1`
    if [ $? == 0 -a "$kill_report" == "" ]; then
      return 0
    else
      #echo "Stale PID file exists at $PID_FILE"
      return 1
    fi
  fi
}

start() {
  if pid_running; then
    echo "$NAME is alreadying running as process `cat ${PID_FILE}`."
    return 0
  fi
  echo -n "Starting $NAME ..."
  rm -f ${STOP_FILE}
  nohup ${START_CMD} &>/${APP_HOME}/logs/console.log &
  PID=$!
  echo "${PID}" > ${PID_FILE}
  local -i cnt=0
  while [ $cnt -lt 10 ]; do 
    if ping_server; then
      echo " Done (pid=${PID})"
      return 0
    fi
    echo -n "."
    let cnt++
    sleep 3
  done
  if pid_running; then
    echo ""
    echo "$NAME is running as process `cat ${PID_FILE}`, but keepalive ping failed."
    return 0
  else
    echo "Failed."
    return 1
  fi
}

stop() {
  if pid_running; then
    echo -n "Stopping $NAME (pid=`cat ${PID_FILE}`) ..."
    touch ${STOP_FILE}
    sleep 10 # jobs take time to stop
    local -i cnt=0
    while [ $cnt -lt 30 ]; do
      if ! pid_running; then
        rm -f ${PID_FILE} 2>/dev/null
        echo " Done."
        return 0
      fi
      echo -n "."
      let cnt++
      sleep 3
    done
    echo ""
    echo "Stop file ${STOP_FILE} touched, but process (pid=`cat ${PID_FILE}`) is still running."
    echo -n "Trying to kill it forcedly ..."
    kill -9 `cat ${PID_FILE}`
    cnt=0
    while [ $cnt -lt 10 ]; do
      if ! pid_running; then
        rm -f ${PID_FILE} 2>/dev/null
        rm -f ${STOP_FILE} 2>/dev/null
        echo " Done."
        return 0
      fi
      echo -n "."
      let cnt++
      sleep 3
    done
    echo " Failed."
    return 1
  else
    echo "$NAME is not running."
    return 0
  fi
}

status() {
  if pid_running; then
    if ping_server; then
      echo "$NAME is running."
    else
      echo "$NAME is running, but keepalive ping failed."
    fi
  else
    echo "$NAME is not running."
  fi
}

case "$1" in
  start)
    start
    ;;  
  stop)
    stop
    ;;  
  status)
    status
    ;;
  restart)
    stop
    start
    ;;
  *)  
    echo "Usage: $0 {start|stop|restart|status}"
    ;;
esac