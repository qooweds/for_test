#/bin/sh
CONFIG_FILE="list_uc.csv"
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

    gm_port=${ARR_GM_PORT[i]}
    server_ip=${ARR_SERVER_IP[i]}

echo $server_ip
echo $gm_port




        /usr/local/bin/python /data/xy/shengbei_s10_9010/gm/gm.py $server_ip $gm_port 1 SSMSG_GM_SEND_ALL_MAIL_REQ "MailInfo(src_role_id=0,src_name=unicode('系统管理员'),title=unicode('10月4日凌晨维护补偿'),content=unicode('补偿已发放，祝您游戏愉快！'),money=BankInfo(coin=200000),item_list=[MailItem(item_tid=89501 ,item_count=2)])"

  sleep 1
done
