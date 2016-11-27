#!/bin/bash

CONFIG_FILE="list_uc.csv"
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
  if [ "$1" == "${ARR_SERVER_ID[i]}" ];then
    platform_server_id=${ARR_PLATFORM_SERVER_ID[i]}
    server_ip=${ARR_SERVER_IP[i]}
    server_path=${ARR_SERVER_PATH[i]}
    server_db_name=${ARR_SERVER_DB_NAME[i]}
    server_db_ip=${ARR_SERVER_DB_IP[i]}
    db_port=${ARR_SERVER_PORT[i]}
    break
  fi
done

server_id="$1"

echo "5 */2 * * * /bin/bash /$server_path/gm/gen_rank_xml.sh  > /$server_path/gm/rank.log 2>&1" >>rank_tmp.txt
echo "5 */2 * * * /bin/bash /$server_path/gm/gen_rank_xml.sh  > /$server_path/gm/rank.log 2>&1" 
#cat rank_tmp.txt > $a
#echo $a
ssh kingnet@$server_ip  "(/usr/bin/crontab -l;echo '5 */2 * * * /bin/bash /${server_path}/gm/gen_rank_xml.sh  > /${server_path}/gm/rank.log 2>&1') |/usr/bin/crontab"

