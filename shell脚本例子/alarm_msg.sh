#!/bin/sh

SERVER_ID=$1
SERVER_IP=$2
#ARR_PHONE_NUM=(15001702933,13816050665,13764020604,18217269686)
ARR_PHONE_NUM=(15001702933)
DATE_TIME=`date "+%m/%d %H:%M"`

for((i=0;i<${#ARR_PHONE_NUM[@]};i++))
do
curl -d "tel=${ARR_PHONE_NUM[i]}" -d "msg=$SERVER_ID $SERVER_IP warning $DATE_TIME" -d "type=3" "http://owl.xy.com/router.php?c=api&a=sendMsg"
curl -d "mobile=${ARR_PHONE_NUM[i]}" -d "content=$SERVER_ID $SERVER_IP warning $DATE_TIME" -d "userid=739" -d "account=veazhang" -d "password=zhangwei1984" "http://121.199.10.236:9001/sms.aspx?action=send"
done
