#!/bin/sh

DB_CONN="mysql -uroot -h192.168.78.139"
LOG_PATH="/home/kingnet/lic"
CONFIG_FILE="/home/kingnet/lic/server.txt" #server.txt need to configure when server changed
DATEBASE="shb_analyzer"

DEL_COIN_DATE=$(date -d "-10 day" "+%Y-%m-%d") #save coin data 10 days
DEL_ALL_DATE=$(date -d "-20 day" "+%Y-%m-%d") #save all money data 20 days
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
    
    ${DB_CONN} -e "use $DATEBASE;load data local infile   '"$LOG_PATH"/money_log_tmp.txt'   into table money_log   fields terminated by '\|'   lines terminated by '\n';"
    ${DB_CONN} -e "use $DATEBASE;load data local infile   '"$LOG_PATH"/item_log_tmp.txt'   into table item_log   fields terminated by '\|'   lines terminated by '\n';"
    ${DB_CONN} -e "use $DATEBASE;load data local infile   '"$LOG_PATH"/trade_log_tmp.txt'   into table trade_log   fields terminated by '\|'   lines terminated by '\n';"
    ${DB_CONN} -e "use $DATEBASE;load data local infile   '"$LOG_PATH"/bill_log_tmp.txt'   into table bill_log   fields terminated by '\|'   lines terminated by '\n';"
   
    rm $LOG_PATH/*_log_tmp.txt
    rm $SRC_PATH/$MONEY_LOG $SRC_PATH/$ITEM_LOG $SRC_PATH/$TRADE_LOG $SRC_PATH/$BILL_LOG

    if [ `date "+%H"` -eq 23 ]; then #when hour=23,delete the data
        ${DB_CONN} -e "use '$DATEBASE';delete from money_log where time like '%$DEL_COIN_DATE%' and money_type like 'GOLD_COIN';"
        ${DB_CONN} -e "use '$DATEBASE';delete from money_log where time like '%$DEL_ALL_DATE%';"
    fi
done


