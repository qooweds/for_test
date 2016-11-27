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

echo $1 $2
for((i=1;i<${#ARR_SERVER_ID[@]};i++))
do
  if [ "$2" == "${ARR_SERVER_ID[i]}" ];then
    SERVER_ID=${ARR_SERVER_ID[i]}
    PLATFORM_SERVER_ID=${ARR_PLATFORM_SERVER_ID[i]}
    SERVER_IP=${ARR_SERVER_IP[i]}
    SERVER_PATH=${ARR_SERVER_PATH[i]}
    SERVER_DB_NAME=${ARR_SERVER_DB_NAME[i]}
    SERVER_DB_IP=${ARR_SERVER_DB_IP[i]}
    DB_PORT=${ARR_SERVER_PORT[i]}
  break
  fi
echo $SERVER_ID
done
#    mysqldump -ushengxy -pdq32t61q -h$SERVER_DB_IP -P$DB_PORT $SERVER_DB_NAME --skip-add-drop-table --skip-add-locks --no-create-info --no-create-db --skip-opt > /data/tools/sql_dump/"$SERVER_ID"_merge.sql
    mysql -ushengxy -pdq32t61q -h$SERVER_DB_IP -P$DB_PORT $SERVER_DB_NAME -f < /data/tools/sql_dump/"$1"_backup.sql
    mysql -ushengxy -pdq32t61q -h$SERVER_DB_IP -P$DB_PORT $SERVER_DB_NAME < /data/tools/delete_invalid_data.sql
