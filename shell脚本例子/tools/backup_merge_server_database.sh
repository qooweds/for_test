#!/bin/sh

CONFIG_FILE="list_merge.csv"
ARR_SERVER_ID=($(awk 'BEGIN{FS=","}{print $1}' $CONFIG_FILE))
ARR_PLATFORM_SERVER_ID=($(awk 'BEGIN{FS=","}{print $2}' $CONFIG_FILE))
ARR_SERVER_IP=($(awk 'BEGIN{FS=","}{print $3}' $CONFIG_FILE))
ARR_SERVER_PATH=($(awk 'BEGIN{FS=","}{print $4}' $CONFIG_FILE))
ARR_SERVER_DB_NAME=($(awk 'BEGIN{FS=","}{print $5}' $CONFIG_FILE))
ARR_SERVER_DB_IP=($(awk 'BEGIN{FS=","}{print $6}' $CONFIG_FILE))
REMOTE_GCC_PATH="/opt/app/gcc-4.7.3/lib64"
ARR_SERVER_PORT=($(awk 'BEGIN{FS=","}{print $8}' $CONFIG_FILE))

for((i=1;i<${#ARR_SERVER_ID[@]};i++))
do
    SERVER_ID=${ARR_SERVER_ID[i]}
    PLATFORM_SERVER_ID=${ARR_PLATFORM_SERVER_ID[i]}
    SERVER_IP=${ARR_SERVER_IP[i]}
    SERVER_PATH=${ARR_SERVER_PATH[i]}
    SERVER_DB_NAME=${ARR_SERVER_DB_NAME[i]}
    SERVER_DB_IP=${ARR_SERVER_DB_IP[i]}
    DB_PORT=${ARR_SERVER_PORT[i]}
#    mysqldump -ushengxy -pdq32t61q -h$SERVER_DB_IP -P$DB_PORT $SERVER_DB_NAME --skip-add-drop-table --skip-add-locks --no-create-info --no-create-db --skip-opt > /data/tools/backup/"$SERVER_ID"_value.sql
    echo "$SERVER_ID"
#check server is or not running
    CMD=`ssh kingnet@${SERVER_IP} "LD_LIBRARY_PATH=$REMOTE_GCC_PATH /bin/bash /$SERVER_PATH/server_ctl.sh check"`
    if [ "$CMD" == "ok" ];then
      echo "$SERVER_ID is running"
      exit
    fi
    echo "Origin data dump:(can stop)"
    mysqldump -uroot -ppgOofEQV7jCM -h$SERVER_DB_IP -P$DB_PORT $SERVER_DB_NAME --skip-add-drop-table --skip-add-locks --no-create-info --no-create-db > /data/tools/backup/"$SERVER_ID"_backup_one_database.sql

done
