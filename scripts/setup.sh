#/bin/sh

info() {
    echo "[Setup] INFO - $1"
}

error() {
    echo "[Setup] ERROR - $1"
    exit 1
}

if [ `id -u` != 0 ]; then
  error "Must run as root!"
fi

usage() {
  error "Usage: $0 -h host_ip [-e env_name] -u app_user -g app_group -l physical_log_dir"
}

resolve_vars() {
    local template_file=$1
    local target_file=$2
    shift 2

    while [ -n "$1" ]; do
        source "$1"
        shift
    done

    sed 's/"/\\\\"/g' ${template_file} | while IFS='' read line; do eval "echo \"$line\"" ; done > ${target_file}
}

APP_NAME=comments-api
APP_HOME="$(cd -L "$(dirname $0)/.." && pwd)"
APP_USER=
APP_GROUP=
PHYSICAL_LOG_DIR=
HOST_IP=
ENV_NAME=

while getopts h:e:u:g:l: flag; do
  case $flag in
    h)
      HOST_IP=$OPTARG
      ;;
    e) 
      ENV_NAME=$OPTARG
      ;;
    u)
      APP_USER=$OPTARG
      ;;
    g)
      APP_GROUP=$OPTARG
      ;;
    l)
      PHYSICAL_LOG_DIR=$OPTARG
      ;;
    ?)
      usage
      ;;
  esac
done
shift $(( OPTIND - 1 ))

if [ -z "${APP_USER}" -o -z "${APP_GROUP}" -o -z "${PHYSICAL_LOG_DIR}" -o -z "${HOST_IP}" ]; then
  usage
fi

info "APP_HOME: ${APP_HOME}"
info "HOST_IP:  ${HOST_IP}"
info "ENV_NAME: ${ENV_NAME}"

#########################
### Set dir/file owner
#########################
chown -R ${APP_USER}:${APP_GROUP} ${APP_HOME} && \
    info "set owner/group of ${APP_HOME} to ${APP_USER}:${APP_GROUP}."

if [ $? -ne 0 ]; then
    error "Failed to set owner/group of ${APP_HOME} to ${APP_USER}:${APP_GROUP}."
fi

#########################
### Generate conf file
#########################

CONF_DIR=${APP_HOME}/conf
ENV_DIR=${APP_HOME}/env
conf_global_vars=${ENV_DIR}/global
conf_env_vars=`find ${ENV_DIR}/${ENV_NAME} -name "${HOST_IP}" | head -n1`
if [ -z ${conf_env_vars} ]; then
    error "Cannot find env file ${HOST_IP} under ${ENV_DIR}."
fi

conf=${CONF_DIR}/app.conf
conf_template=${conf}.template
conf_target=${conf_env_vars}.conf

resolve_vars ${conf_template} ${conf_target} ${conf_global_vars} ${conf_env_vars} && \
    chown ${APP_USER}:${APP_GROUP} ${conf_target} && \
    rm -f ${conf} && \
    ln -sfn ${conf_target} ${conf}  && \
    info "Configuration file generated: ${conf} --> ${conf_target}"

if [ $? -ne 0 ]; then
    error "Failed to generate ${conf} --> ${conf_target}."
fi

###########################
### Generate initd script
###########################

initd_script_template=${APP_HOME}/scripts/${APP_NAME}d
initd_script_target=/etc/init.d/${APP_NAME}d

sed -e "s@__APP_HOME__@${APP_HOME}@g" -e "s@__RUN_USER__@${APP_USER}@g" ${initd_script_template} > ${initd_script_target} && \
    chown root:root ${initd_script_target} && \
    chmod 755 ${initd_script_target} && \
    info "Service script generated: ${initd_script_target}."

if [ $? -ne 0 ]; then
    error "Failed to generate ${initd_script_target}."
fi

###########################
### Generate ctl script
###########################

ctl_script_template=${APP_HOME}/scripts/${APP_NAME}.ctl
ctl_script_target=${APP_HOME}/${APP_NAME}.ctl

sed "s@__RUN_USER__@${APP_USER}@g" ${ctl_script_template} > ${ctl_script_target} && \
    chown ${APP_USER}:${APP_GROUP} ${ctl_script_target} && chmod 755 ${ctl_script_target} && \
    info "Control script generated: ${ctl_script_target}."

if [ $? -ne 0 ]; then
    error "Failed to generate ${ctl_script_target}."
fi

###########################
### relink the logs dir
###########################

mkdir -p ${PHYSICAL_LOG_DIR} && \
    chown ${APP_USER}:${APP_GROUP} ${PHYSICAL_LOG_DIR} && \
    chmod 755 ${PHYSICAL_LOG_DIR} && \
    rm -rf ${APP_HOME}/logs 2>/dev/null && \
    ln -sfn ${PHYSICAL_LOG_DIR} ${APP_HOME}/logs && \
    info "Logs dir linked: ${APP_HOME}/logs --> ${PHYSICAL_LOG_DIR}"

if [ $? -ne 0 ]; then
    error "Failed to relink logs dir ${APP_HOME}/logs --> ${PHYSICAL_LOG_DIR}."
fi

##########################
### Hide the scripts dir
##########################

if [ -d ${APP_HOME}/scripts ]; then
  mv ${APP_HOME}/scripts ${APP_HOME}/.scripts &>/dev/null 
  chown -R ${APP_USER}:${APP_GROUP} ${APP_HOME}/.scripts &>/dev/null
fi

echo "Setup completed."
exit 0
