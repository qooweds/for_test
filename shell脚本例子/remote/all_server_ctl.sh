#!/bin/sh
CONFIG_FILE="list_.csv"
ARR_SERVER_ID=($(awk 'BEGIN{FS=","}{print $1}' $CONFIG_FILE))
ARR_PLATFORM_SERVER_ID=($(awk 'BEGIN{FS=","}{print $2}' $CONFIG_FILE))
ARR_SERVER_IP=($(awk 'BEGIN{FS=","}{print $3}' $CONFIG_FILE))
ARR_SERVER_PATH=($(awk 'BEGIN{FS=","}{print $4}' $CONFIG_FILE))
ARR_SERVER_DB_NAME=($(awk 'BEGIN{FS=","}{print $5}' $CONFIG_FILE))
ARR_SERVER_DB_IP=($(awk 'BEGIN{FS=","}{print $6}' $CONFIG_FILE))
REMOTE_GCC_PATH="/opt/app/gcc-4.7.3/lib64"

echo $1
#echo $2
for((i=1;i<${#ARR_SERVER_ID[@]};i++))
do
  if [ "$2" == "${ARR_SERVER_ID[i]}" ];then
    SERVER_ID=${ARR_SERVER_ID[i]}
    PLATFORM_SERVER_ID=${ARR_PLATFORM_SERVER_ID[i]}
    SERVER_IP=${ARR_SERVER_IP[i]}
    ARR_SERVER_PATH=${ARR_SERVER_PATH[i]}
    ARR_SERVER_DB_NAME=${ARR_SERVER_DB_NAME[i]}
    ARR_SERVER_DB_IP=${ARR_SERVER_DB_IP[i]}
  fi

if [ "$1" == "stop" ] || [ "$1" == "faststop" ];then
  date >>./log/$SERVER_ID.log
  ssh kingnet@$SERVER_IP -f "LD_LIBRARY_PATH=$REMOTE_GCC_PATH /bin/bash /$ARR_SERVER_PATH/server_ctl.sh $1" >>./log/$SERVER_ID.log
else
  ssh kingnet@$SERVER_IP "LD_LIBRARY_PATH=$REMOTE_GCC_PATH /bin/bash /$ARR_SERVER_PATH/server_ctl.sh $1"
fi
done
