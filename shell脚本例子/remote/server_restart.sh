#!/bin/sh

if [ "${0:0:1}" != "/" ] ; then
    BASE_DIR="$(pwd)/$(dirname $0)"
else
    BASE_DIR="$(dirname $0)"
fi

cd $BASE_DIR
BASE_DIR=$(pwd)


CONFIG_FILE="list_uc_monitor.csv"
if  [ !  -e $CONFIG_FILE ] ; then
    echo "$CONFIG_FILE not exist"
    exit
else
    echo "$CONFIG_FILE is config file"
fi

ARR_SERVER_ID=($(awk 'BEGIN{FS=","}{print $1}' $CONFIG_FILE))
ARR_PLATFORM_SERVER_ID=($(awk 'BEGIN{FS=","}{print $2}' $CONFIG_FILE))
ARR_SERVER_IP=($(awk 'BEGIN{FS=","}{print $3}' $CONFIG_FILE))
ARR_SERVER_PATH=($(awk 'BEGIN{FS=","}{print $4}' $CONFIG_FILE))
ARR_SERVER_DB_NAME=($(awk 'BEGIN{FS=","}{print $5}' $CONFIG_FILE))
ARR_SERVER_DB_IP=($(awk 'BEGIN{FS=","}{print $6}' $CONFIG_FILE))
REMOTE_GCC_PATH="/opt/app/gcc-4.7.3/lib64"
DATE_TIME=`date "+%m/%d %H:%M"`


for((i=1;i<${#ARR_SERVER_ID[@]};i++))
do
    SERVER_ID=${ARR_SERVER_ID[i]}
    PLATFORM_SERVER_ID=${ARR_PLATFORM_SERVER_ID[i]}
    SERVER_IP=${ARR_SERVER_IP[i]}
    SERVER_PATH=${ARR_SERVER_PATH[i]}
    SERVER_DB_NAME=${ARR_SERVER_DB_NAME[i]}
    SERVER_DB_IP=${ARR_SERVER_DB_IP[i]}

    echo $SERVER_ID
    CMD=`ssh kingnet@${SERVER_IP} "LD_LIBRARY_PATH=$REMOTE_GCC_PATH sh /$SERVER_PATH/server_ctl.sh check"`
    if [ "$CMD" != "ok" ];then
      echo "$SERVER_ID is not ok"
      ssh kingnet@$SERVER_IP -f "LD_LIBRARY_PATH=$REMOTE_GCC_PATH sh /$SERVER_PATH/server_ctl.sh start;date" >> /data/remote_server_ctl/log/restart/$SERVER_ID.log
      /bin/bash /opt/app/bin/alarm_msg.sh $SERVER_ID $SERVER_IP
    fi
done
