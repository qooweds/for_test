#!/bin/sh

CONFIG_FILE="list_test.csv"
ARR_SERVER_ID=($(awk 'BEGIN{FS=","}{print $1}' $CONFIG_FILE))
ARR_PLATFORM_SERVER_ID=($(awk 'BEGIN{FS=","}{print $2}' $CONFIG_FILE))
ARR_SERVER_IP=($(awk 'BEGIN{FS=","}{print $3}' $CONFIG_FILE))
ARR_SERVER_PATH=($(awk 'BEGIN{FS=","}{print $4}' $CONFIG_FILE))
ARR_SERVER_DB_NAME=($(awk 'BEGIN{FS=","}{print $5}' $CONFIG_FILE))
ARR_SERVER_DB_IP=($(awk 'BEGIN{FS=","}{print $6}' $CONFIG_FILE))
REMOTE_GCC_PATH="/opt/app/gcc-4.7.3/lib64"
ARR_SERVER_PORT=($(awk 'BEGIN{FS=","}{print $8}' $CONFIG_FILE))
ARR_GM_PORT=($(awk 'BEGIN{FS=","}{print $9}' $CONFIG_FILE))

#echo $1
for((i=1;i<${#ARR_SERVER_ID[@]};i++))
do
#  if [ "$1" == "${ARR_SERVER_ID[i]}" ];then
    SERVER_ID=${ARR_SERVER_ID[i]}
    PLATFORM_SERVER_ID=${ARR_PLATFORM_SERVER_ID[i]}
    SERVER_IP=${ARR_SERVER_IP[i]}
    SERVER_PATH=${ARR_SERVER_PATH[i]}
    SERVER_DB_NAME=${ARR_SERVER_DB_NAME[i]}
    SERVER_DB_IP=${ARR_SERVER_DB_IP[i]}
    DB_PORT=${ARR_SERVER_PORT[i]}
    GM_PORT=${ARR_GM_PORT[i]}
#  fi
echo $SERVER_ID
 
   python /data/remote_server_ctl/gm/gm_tool.py $SERVER_IP $GM_PORT 1 MSG_ACTION_GM_PLUGIN "GMPluginRequest(plugin_name='charge_top_control', arguments='2')" "GMPluginResponse()"
   python /data/remote_server_ctl/gm/gm_tool.py $SERVER_IP $GM_PORT 1 MSG_ACTION_GM_PLUGIN "GMPluginRequest(plugin_name='charge_top_control', arguments='0')" "GMPluginResponse()"
  sleep 2
done
