#!/bin/bash

DB_CONN="mysql -uroot -h192.168.78.139"
CONFIG_FILE="/home/kingnet/lic/server.txt"
DATABASE="shb_analyzer"
TABLE="daily_bill"

FILENAME=$(date -d "-1 day" "+money-%Y-%m-%d.log")
DATE=$(date -d "-1 day" "+%Y-%m-%d")

ARR_SERVER_ID=($(awk '{print $1}' $CONFIG_FILE))
ARR_SRC_PATH=($(awk '{print $3}' $CONFIG_FILE))

for((i=0;i<${#ARR_SERVER_ID[@]};i++))
do
  SERVER_ID=${ARR_SERVER_ID[i]}
  SRC_PATH=${ARR_SRC_PATH[i]}

  S_GOLD_ADD=`awk '{FS="|"} /GOLD_COIN/&&/ADD_MONEY/ {goldadd_sum+=$10} END {print goldadd_sum}' $SRC_PATH/$FILENAME`
  S_GOLD_SUB=`awk '{FS="|"} /GOLD_COIN/&&/SUB_MONEY/ {goldsub_sum+=$10} END {print goldsub_sum}' $SRC_PATH/$FILENAME`
  S_COUPON_ADD=`awk '{FS="|"} /COUPON/&&/ADD_MONEY/ {couponadd_sum+=$10} END {print couponadd_sum}' $SRC_PATH/$FILENAME`
  S_COUPON_SUB=`awk '{FS="|"} /COUPON/&&/SUB_MONEY/ {couponsub_sum+=$10} END {print couponsub_sum}' $SRC_PATH/$FILENAME`
  S_DIAMOND_ADD=`awk '{FS="|"} /DIAMOND/&&/ADD_MONEY/ {diamondadd_sum+=$10} END {print diamondadd_sum}' $SRC_PATH/$FILENAME`
  S_DIAMOND_SUB=`awk '{FS="|"} /DIAMOND/&&/SUB_MONEY/ {diamondsub_sum+=$10} END {print diamondsub_sum}' $SRC_PATH/$FILENAME`

  P_GOLD_ADD=$(echo `awk '{FS="|"} /ADD_MONEY/&&/GOLD/ {arr[$3]+=$10}END{for(i in arr) print "(",i,":",arr[i],")"}' $SRC_PATH/$FILENAME | sort -k4nr -g | head -n 10`)
  P_GOLD_SUB=$(echo `awk '{FS="|"} /SUB_MONEY/&&/GOLD/ {arr[$3]+=$10}END{for(i in arr) print "(",i,":",arr[i],")"}' $SRC_PATH/$FILENAME | sort -k4n -g | head -n 10`)
  P_COUPON_ADD=$(echo `awk '{FS="|"} /ADD_MONEY/&&/COUPON/ {arr[$3]+=$10}END{for(i in arr) print "(",i,":",arr[i],")"}' $SRC_PATH/$FILENAME | sort -k4nr -g | head -n 10`)
  P_COUPON_SUB=$(echo `awk '{FS="|"} /SUB_MONEY/&&/COUPON/ {arr[$3]+=$10}END{for(i in arr) print "(",i,":",arr[i],")"}' $SRC_PATH/$FILENAME | sort -k4n -g | head -n 10`)
  P_DIAMOND_ADD=$(echo `awk '{FS="|"} /ADD_MONEY/&&/DIAMOND/ {arr[$3]+=$10}END{for(i in arr) print "(",i,":",arr[i],")"}' $SRC_PATH/$FILENAME | sort -k4nr -g | head -n 10`)
  P_DIAMOND_SUB=$(echo `awk '{FS="|"} /SUB_MONEY/&&/DIAMOND/ {arr[$3]+=$10}END{for(i in arr) print "(",i,":",arr[i],")"}' $SRC_PATH/$FILENAME | sort -k4n -g | head -n 10`)
  {
    echo $SERVER_ID
    echo $DATE
    echo $S_GOLD_ADD
    echo $S_GOLD_SUB
    echo $S_COUPON_ADD
    echo $S_COUPON_SUB
    echo $S_DIAMOND_ADD
    echo $S_DIAMOND_SUB
    echo $P_GOLD_ADD
    echo $P_GOLD_SUB
    echo $P_COUPON_ADD
    echo $P_COUPON_SUB
    echo $P_DIAMOND_ADD
    echo $P_DIAMOND_SUB 
  } > ./lic_currency.txt
#  ${DB_CONN} -e "use $DATABASE;load data local infile   'lic_currency.txt' into table $TABLE fields terminated by '\n';"
  rm ./lic_currency.txt
  rm $SRC_PATH/$FILENAME
done
