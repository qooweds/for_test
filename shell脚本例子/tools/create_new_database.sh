#!/bin/sh

CONFIG_FILE="list_uc.csv"
ARR_SERVER_ID=($(awk 'BEGIN{FS=","}{print $1}' $CONFIG_FILE))
ARR_PLATFORM_SERVER_ID=($(awk 'BEGIN{FS=","}{print $2}' $CONFIG_FILE))
ARR_SERVER_IP=($(awk 'BEGIN{FS=","}{print $3}' $CONFIG_FILE))
ARR_SERVER_PATH=($(awk 'BEGIN{FS=","}{print $4}' $CONFIG_FILE))
ARR_SERVER_DB_NAME=($(awk 'BEGIN{FS=","}{print $5}' $CONFIG_FILE))
ARR_SERVER_DB_IP=($(awk 'BEGIN{FS=","}{print $6}' $CONFIG_FILE))
REMOTE_GCC_PATH="/opt/app/gcc-4.7.3/lib64"
ARR_SERVER_PORT=($(awk 'BEGIN{FS=","}{print $8}' $CONFIG_FILE))
CREATE_DB_SERVER_ID="$1"

#echo $1
for((i=1;i<${#ARR_SERVER_ID[@]};i++))
do
  if [ "$1" == "${ARR_SERVER_ID[i]}" ];then
    SERVER_ID=${ARR_SERVER_ID[i]}
    PLATFORM_SERVER_ID=${ARR_PLATFORM_SERVER_ID[i]}
    SERVER_IP=${ARR_SERVER_IP[i]}
    SERVER_PATH=${ARR_SERVER_PATH[i]}
    SERVER_DB_NAME=${ARR_SERVER_DB_NAME[i]}
    SERVER_DB_IP=${ARR_SERVER_DB_IP[i]}
    DB_PORT=${ARR_SERVER_PORT[i]}
    break
  fi
done

  #check if the db is online
  CMD=`ssh kingnet@$SERVER_IP "/opt/app/mysql/bin/mysql -uroot -ppgOofEQV7jCM -h$SERVER_DB_IP -P$DB_PORT $SERVER_DB_NAME -e \"select * from used_userid limit 1;\" |wc -l "`
  if [ "$CMD" -gt 1 ];then
    echo "$1 is being running!!"
    exit
  fi

  echo "create user in server_ip:$SERVER_IP in DB:$SERVER_DB_IP:$DB_PORT :"
  ssh kingnet@$SERVER_IP "/opt/app/mysql/bin/mysql -uroot -ppgOofEQV7jCM -h$SERVER_DB_IP -P$DB_PORT -e \"insert into mysql.user(Host,User,Password) values('$SERVER_IP','shengxy',password('dq32t61q'));\" " 
  echo ""

  echo "create user in server_ip:10.6.7.157 in DB:$SERVER_DB_IP:$DB_PORT :"
  ssh kingnet@$SERVER_IP "/opt/app/mysql/bin/mysql -uroot -ppgOofEQV7jCM -h$SERVER_DB_IP -P$DB_PORT -e \"insert into mysql.user(Host,User,Password) values('10.6.7.157','shengxy',password('dq32t61q'));\" "
  echo ""

  echo "flush privileges:"
  ssh kingnet@$SERVER_IP "/opt/app/mysql/bin/mysql -uroot -ppgOofEQV7jCM -h$SERVER_DB_IP -P$DB_PORT -e \"flush privileges;\" "
  echo ""
  
  echo "grant access permission to $SERVER_DB_NAME in server_ip:$SERVER_IP :"
  ssh kingnet@$SERVER_IP "/opt/app/mysql/bin/mysql -uroot -ppgOofEQV7jCM -h$SERVER_DB_IP -P$DB_PORT -e \"grant select, insert, update, delete, create ,alter,index  on $SERVER_DB_NAME.* to shengxy@$SERVER_IP identified by 'dq32t61q';\" "
  echo ""

  echo "grant access permission to $SERVER_DB_NAME in server_ip:10.6.7.157 :"
  ssh kingnet@$SERVER_IP "/opt/app/mysql/bin/mysql -uroot -ppgOofEQV7jCM -h$SERVER_DB_IP -P$DB_PORT -e \"grant select, insert, update, delete, create ,alter,index  on $SERVER_DB_NAME.* to shengxy@10.6.7.157 identified by 'dq32t61q';\" "
  echo ""

  echo "create DB $SERVER_DB_NAME :"
  ssh kingnet@$SERVER_IP "/opt/app/mysql/bin/mysql -uroot -ppgOofEQV7jCM -h$SERVER_DB_IP -P$DB_PORT -e \"create database $SERVER_DB_NAME;\" "
  echo ""

  echo "create tables :"
  ssh kingnet@$SERVER_IP "/opt/app/mysql/bin/mysql -ushengxy -pdq32t61q -h$SERVER_DB_IP -P$DB_PORT $SERVER_DB_NAME < /$SERVER_PATH/sql/game.sql "

