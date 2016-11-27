#!/bin/sh

CONFIG_FILE="removal_db_list.csv"
ARR_DB_NAME=($(awk '{print $1}' $CONFIG_FILE))
ARR_OLD_IP=($(awk '{print $2}' $CONFIG_FILE))
ARR_NEW_IP=($(awk '{print $3}' $CONFIG_FILE))
ARR_OLD_PORT=($(awk '{print $4}' $CONFIG_FILE))
ARR_NEW_PORT=($(awk '{print $5}' $CONFIG_FILE))



for((i=0;i<${#ARR_DB_NAME[@]};i++))
do
  db_name=${ARR_DB_NAME[i]}
  old_ip=${ARR_OLD_IP[i]}
  new_ip=${ARR_NEW_IP[i]}
  echo $db_name :

#check db is or not in new_bd
  CMD=`mysql -uroot -ppgOofEQV7jCM -h$new_ip  $db_name -e "select * from used_userid limit 1;"|wc -l`
echo mysql -uroot -ppgOofEQV7jCM -h$new_ip  $db_name 
  if [ "$CMD" -gt 1 ];then
    echo "$1 is being running!!"
    exit
  fi

  echo   "mysqldump -uroot -ppgOofEQV7jCM -h$old_ip  $db_name > move_db_backup/$db_name.sql"
  mysqldump -uroot -ppgOofEQV7jCM -h$old_ip  $db_name > /data/tools/move_db_backup/$db_name.sql

  echo  mysql -uroot -ppgOofEQV7jCM -h$new_ip  -e "create database $db_name;"
  mysql -uroot -ppgOofEQV7jCM -h$new_ip  -e "create database $db_name;"

  echo  "mysql -uroot -ppgOofEQV7jCM -h$new_ip  $db_name < move_db_backup/$db_name.sql"
  mysql -uroot -ppgOofEQV7jCM -h$new_ip  $db_name < /data/tools/move_db_backup/$db_name.sql
  
 

done
#mysqldump -uroot -ppgOofEQV7jCM
echo "done!"
