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

echo "Above server will be merged to :"
read main_server


for((i=1;i<${#ARR_SERVER_ID[@]};i++))
do
  if [ "$main_server" == "${ARR_SERVER_ID[i]}" ];then
    main_server_id=${ARR_SERVER_ID[i]}
    main_server_ip=${ARR_SERVER_IP[i]}
    main_server_path=${ARR_SERVER_PATH[i]}
    main_db_name=${ARR_SERVER_DB_NAME[i]}
    main_db_ip=${ARR_SERVER_DB_IP[i]}
    main_db_port=${ARR_SERVER_PORT[i]}
    break
  fi
done

    CMD=`ssh kingnet@${main_server_ip} "LD_LIBRARY_PATH=$REMOTE_GCC_PATH /bin/bash /$main_server_path/server_ctl.sh check"`
    if [ "$CMD" = "ok" ];then
      echo "$main_server_id is running"
      exit
    fi
    echo "dump $main_server:"
#    mysqldump -uroot -ppgOofEQV7jCM -h$main_db_ip -P$main_db_port $main_db_name --skip-add-drop-table --skip-add-locks --no-create-info > /data/tools/backup/"$main_server_id"_origin.sql

for((i=1;i<${#ARR_SERVER_ID[@]};i++))
do
  if [ "$1" == "${ARR_SERVER_ID[i]}" ] || [ "$2" == "${ARR_SERVER_ID[i]}" ] || [ "$3" == "${ARR_SERVER_ID[i]}" ] || [ "$4" == "${ARR_SERVER_ID[i]}" ] || [ "$5" == "${ARR_SERVER_ID[i]}" ];then
    SERVER_ID=${ARR_SERVER_ID[i]}
    PLATFORM_SERVER_ID=${ARR_PLATFORM_SERVER_ID[i]}
    SERVER_IP=${ARR_SERVER_IP[i]}
    SERVER_PATH=${ARR_SERVER_PATH[i]}
    SERVER_DB_NAME=${ARR_SERVER_DB_NAME[i]}
    SERVER_DB_IP=${ARR_SERVER_DB_IP[i]}
    DB_PORT=${ARR_SERVER_PORT[i]}
#    mysqldump -uroot -ppgOofEQV7jCM -h$SERVER_DB_IP -P$DB_PORT $SERVER_DB_NAME --skip-add-drop-table --skip-add-locks --no-create-info --no-create-db --skip-opt > /data/tools/backup/"$SERVER_ID"_value.sql
    echo "$SERVER_ID"
#check server is or not running
    CMD=`ssh kingnet@${SERVER_IP} "LD_LIBRARY_PATH=$REMOTE_GCC_PATH /bin/bash /$SERVER_PATH/server_ctl.sh check"`
    if [ "$CMD" == "ok" ];then
      echo "$SERVER_ID is running"
      exit
    fi
#    echo "Origin data dump:(can stop)"
#    mysqldump -uroot -ppgOofEQV7jCM -h$SERVER_DB_IP -P$DB_PORT $SERVER_DB_NAME --skip-add-drop-table --skip-add-locks --no-create-info --no-create-db > /data/tools/backup/"$SERVER_ID"_origin.sql
    echo "Delete invalid data:"
    mysql -uroot -ppgOofEQV7jCM -h$SERVER_DB_IP -P$DB_PORT $SERVER_DB_NAME < delete_invalid_data.sql
    echo "Insert data dump:(can stop)"
    mysqldump -uroot -ppgOofEQV7jCM -h$SERVER_DB_IP -P$DB_PORT $SERVER_DB_NAME --skip-add-drop-table --skip-add-locks --no-create-info --no-create-db > /data/tools/sql_dump/"$SERVER_ID"_for_insert.sql

    echo "load $SERVER_ID data into $main_server:"
    mysql -uroot -ppgOofEQV7jCM -h$main_db_ip -P$main_db_port $main_db_name < /data/tools/sql_dump/"$SERVER_ID"_for_insert.sql
    echo ""
   fi
done

echo "delete $main_server invalid data:"
mysql -uroot -ppgOofEQV7jCM -h$main_db_ip -P$main_db_port $main_db_name < delete_main_server_data.sql
