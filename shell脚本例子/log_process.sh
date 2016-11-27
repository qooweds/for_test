#!/usr/sh

DB_CONN="mysql -uroot -h192.168.78.10"
LOG_PATH="/home/lic/log/work"
CONFIG_FILE="/home/lic/log/work/server.txt" #server.txt need to configure

TIME=$(date -d "-1 hour" "+%Y-%m-%d %H")
MONEY_LOG=$(date -d "-0 day" "+money-%Y-%m-%d.log")
ITEM_LOG=$(date -d "-0 day" "+item-%Y-%m-%d.log")
TRADE_LOG=$(date -d "-0 day" "+trade-%Y-%m-%d.log")
BILL_LOG=$(date -d "-0 day" "+bill-%Y-%m-%d.log")

if [ $(date '+%H') = 00 ] ; then
   MONEY_LOG=$(date -d "-1 day" "+money-%Y-%m-%d.log")
   ITEM_LOG=$(date -d "-1 day" "+item-%Y-%m-%d.log")
   TRADE_LOG=$(date -d "-1 day" "+trade-%Y-%m-%d.log")
   BILL_LOG=$(date -d "-1 day" "+bill-%Y-%m-%d.log")
fi

ARR_SERVER_ID=($(awk '{print $1}' $CONFIG_FILE)) 
ARR_SRC_PATH=($(awk '{print $3}' $CONFIG_FILE))

for((i=0;i<${#ARR_SERVER_ID[@]};i++))
do 
  SERVER_ID=${ARR_SERVER_ID[i]}
  SRC_PATH=${ARR_SRC_PATH[i]}

  awk 'BEGIN{FS="|"} {if($1~/'"$TIME"'/) print "'"$SERVER_ID|"'",$0}' $SRC_PATH/$MONEY_LOG > $LOG_PATH/money_log_tmp.txt
  awk 'BEGIN{FS="|"} {if($1~/'"$TIME"'/) print "'"$SERVER_ID|"'",$0}' $SRC_PATH/$ITEM_LOG > $LOG_PATH/item_log_tmp.txt
  awk 'BEGIN{FS="|"} {if($1~/'"$TIME"'/) print "'"$SERVER_ID|"'",$0}' $SRC_PATH/$TRADE_LOG > $LOG_PATH/trade_log_tmp.txt
  awk 'BEGIN{FS="|"} {if($1~/'"$TIME"'/) print "'"$SERVER_ID|"'",$0}' $SRC_PATH/$BILL_LOG > $LOG_PATH/bill_log_tmp.txt

  ${DB_CONN} -e "use trade_log;load data local infile   '"$LOG_PATH"/money_log_tmp.txt'   into table money_log   fields terminated by '\|'   lines terminated by '\n';"
  ${DB_CONN} -e "use trade_log;load data local infile   '"$LOG_PATH"/item_log_tmp.txt'   into table item_log   fields terminated by '\|'   lines terminated by '\n';"
  ${DB_CONN} -e "use trade_log;load data local infile   '"$LOG_PATH"/trade_log_tmp.txt'   into table trade_log   fields terminated by '\|'   lines terminated by '\n';"
  ${DB_CONN} -e "use trade_log;load data local infile   '"$LOG_PATH"/bill_log_tmp.txt'   into table bill_log   fields terminated by '\|'   lines terminated by '\n';"

  rm $LOG_PATH/*_log_tmp.txt
  rm $SRC_PATH/$MONEY_LOG $SRC_PATH/$ITEM_LOG $SRC_PATH/$TRADE_LOG $SRC_PATH/$BILL_LOG
done

