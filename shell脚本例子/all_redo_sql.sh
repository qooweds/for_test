#!/bin/sh
CONFIG_FILE="../list_uc_monitor.csv"
ARR_SERVER_ID=($(awk 'BEGIN{FS=","}{print $1}' $CONFIG_FILE))
ARR_PLATFORM_SERVER_ID=($(awk 'BEGIN{FS=","}{print $2}' $CONFIG_FILE))
ARR_SERVER_IP=($(awk 'BEGIN{FS=","}{print $3}' $CONFIG_FILE))
ARR_SERVER_PATH=($(awk 'BEGIN{FS=","}{print $4}' $CONFIG_FILE))
ARR_SERVER_DB_NAME=($(awk 'BEGIN{FS=","}{print $5}' $CONFIG_FILE))
ARR_SERVER_DB_IP=($(awk 'BEGIN{FS=","}{print $6}' $CONFIG_FILE))
REMOTE_GCC_PATH="/opt/app/gcc-4.7.3/lib64"



for((i=1;i<${#ARR_SERVER_ID[@]};i++))
do
#  if [ "$1" == "${ARR_SERVER_ID[i]}" ];then
    SERVER_ID=${ARR_SERVER_ID[i]}
    PLATFORM_SERVER_ID=${ARR_PLATFORM_SERVER_ID[i]}
    SERVER_IP=${ARR_SERVER_IP[i]}
    SERVER_PATH=${ARR_SERVER_PATH[i]}
    ARR_SERVER_DB_NAME=${ARR_SERVER_DB_NAME[i]}
    ARR_SERVER_DB_IP=${ARR_SERVER_DB_IP[i]}

#  echo $SERVER_ID
#  echo $SERVER_PATH
  ssh kingnet@$SERVER_IP -f "/usr/local/bin/python /$SERVER_PATH/tools/redo_last_hour_sql.py >> /$SERVER_PATH/tools/redo.log"
#  echo "/usr/local/bin/python /$SERVER_PATH/tools/redo_last_hour_sql.py > /$SERVER_PATH/tools/redo.log"
#  fi
done
