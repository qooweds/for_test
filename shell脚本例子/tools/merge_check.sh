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
    main_server_id=${ARR_SERVER_ID[i]}
    main_server_ip=${ARR_SERVER_IP[i]}
    main_server_path=${ARR_SERVER_PATH[i]}
    main_db_name=${ARR_SERVER_DB_NAME[i]}
    main_db_ip=${ARR_SERVER_DB_IP[i]}
    main_db_port=${ARR_SERVER_PORT[i]}

    mysql -uroot -ppgOofEQV7jCM -h$main_db_ip -P$main_db_port $main_db_name -e "select * from guild_info limit 1;"
done
