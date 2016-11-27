#!/bin/sh

CONFIG_FILE="list_uc.csv"
ARR_SERVER_ID=($(awk 'BEGIN{FS=","}{print $1}' $CONFIG_FILE))
ARR_PLATFORM_SERVER_ID=($(awk 'BEGIN{FS=","}{print $2}' $CONFIG_FILE))
ARR_SERVER_IP=($(awk 'BEGIN{FS=","}{print $3}' $CONFIG_FILE))
ARR_SERVER_PATH=($(awk 'BEGIN{FS=","}{print $4}' $CONFIG_FILE))
ARR_SERVER_DB_NAME=($(awk 'BEGIN{FS=","}{print $5}' $CONFIG_FILE))
ARR_SERVER_DB_IP=($(awk 'BEGIN{FS=","}{print $6}' $CONFIG_FILE))
REMOTE_GCC_PATH="/opt/app/gcc-4.7.3/lib64"
#ARR_PHONE_NUM=(15001702933,13816050665,13764020604,18217269686)
ARR_PHONE_NUM=(15001702933)
DATE_TIME=`date "+%m/%d %H:%M"`

echo $1
echo $2
for((i=1;i<${#ARR_SERVER_ID[@]};i++))
do
  SERVER_ID=${ARR_SERVER_ID[i]}
  PLATFORM_SERVER_ID=${ARR_PLATFORM_SERVER_ID[i]}
  SERVER_IP=${ARR_SERVER_IP[i]}
  ARR_SERVER_PATH=${ARR_SERVER_PATH[i]}
  ARR_SERVER_DB_NAME=${ARR_SERVER_DB_NAME[i]}
  ARR_SERVER_DB_IP=${ARR_SERVER_DB_IP[i]}
  
  echo $SERVER_ID
  CMD=`ssh kingnet@${SERVER_IP} "LD_LIBRARY_PATH=${REMOTE_GCC_PATH} /bin/bash /${ARR_SERVER_PATH}/server_ctl.sh check"`
#    ssh kingnet@${SERVER_IP} "LD_LIBRARY_PATH=${REMOTE_GCC_PATH} sh /${ARR_SERVER_PATH}/server_ctl.sh check"
  if [ "$CMD" != "ok" ];then
    echo "$SERVER_ID is not ok" >>log/test.log
    for((j=0;j<${#ARR_PHONE_NUM[@]};j++))
      do
      curl -d "tel=${ARR_PHONE_NUM[j]}" -d "msg=$SERVER_ID warning 157 test $DATE_TIME" -d "type=3" "http://owl.xy.com/router.php?c=api&a=sendMsg"
      curl -d "mobile=${ARR_PHONE_NUM[j]}" -d "content=$SERVER_ID warning 157 test $DATE_TIME" -d "userid=739" -d "account=veazhang" -d "password=zhangwei1984" "http://121.199.10.236:9001/sms.aspx?action=send"
      echo $SERVER_ID > log/msg.log
      done
  fi
    

done

echo "Done!"
