#!/bin/sh
SRC_PATH="/opt/app/shengbei/deploy0530/log_server"
DES_PATH="/home/lic/log/work"
CONFIG_FILE="/home/lic/log/work/server.txt" #server.txt need to configure

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

ARR_SRC=($(awk '{print $2}' $CONFIG_FILE))
ARR_DES=($(awk '{print $3}' $CONFIG_FILE))

for((i=0;i<${#ARR_SRC[@]};i++))
do
#  echo ${ARR_SRC[i]}/$MONEY_LOG
  scp ${ARR_SRC[i]}/$MONEY_LOG ${ARR_SRC[i]}/$ITEM_LOG ${ARR_SRC[i]}/$TRADE_LOG ${ARR_SRC[i]}/$BILL_LOG ${ARR_DES[i]}
done
