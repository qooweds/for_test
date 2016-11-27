#!/bin/bash

FILENAME=$(date -d "-1 day" "+money-%Y-%m-%d.log")
DATE=$(date -d "-1 day" "+%Y-%m-%d")
SRC_PATH=/opt/app/shengbei/deploy0530/log_server
{
echo "Dependent on "$FILENAME" (no data means 0)"
echo
echo "Money in server:"
awk '{FS="|"} /GOLD_COIN/&&/ADD_MONEY/ {goldadd_sum+=$8} END {print "coin add count: "goldadd_sum}' $SRC_PATH/$FILENAME
awk '{FS="|"} /GOLD_COIN/&&/SUB_MONEY/ {goldsub_sum+=$8} END {print "coin sub count: "goldsub_sum}' $SRC_PATH/$FILENAME
awk '{FS="|"} /COUPON/&&/ADD_MONEY/ {couponadd_sum+=$8} END {print "coupon add count: "couponadd_sum}' $SRC_PATH/$FILENAME
awk '{FS="|"} /COUPON/&&/SUB_MONEY/ {couponsub_sum+=$8} END {print "coupon sub count: "couponsub_sum}' $SRC_PATH/$FILENAME
awk '{FS="|"} /DIAMOND/&&/ADD_MONEY/ {diamondadd_sum+=$8} END {print "diamond add count: "diamondadd_sum}' $SRC_PATH/$FILENAME
awk '{FS="|"} /DIAMOND/&&/SUB_MONEY/ {diamondsub_sum+=$8} END {print "diamond sub count: "diamondsub_sum}' $SRC_PATH/$FILENAME
echo
echo "10Players get most coin:(uid/count)"
awk '{FS="|"} /ADD_MONEY/&&/GOLD/ {arr[$3]+=$8}END{for(i in arr) print i,arr[i]}' $SRC_PATH/$FILENAME | sort -k2nr -g | head -n 10
echo "10players get most coupon:(uid/count)"
awk '{FS="|"} /ADD_MONEY/&&/COUPON/ {arr[$3]+=$8}END{for(i in arr) print i,arr[i]}' $SRC_PATH/$FILENAME | sort -k2nr -g | head -n 10
echo "10players get most diamond:(uid/count)"
awk '{FS="|"} /ADD_MONEY/&&/DIAMOND/ {arr[$3]+=$8}END{for(i in arr) print i,arr[i]}' $SRC_PATH/$FILENAME | sort -k2nr -g | head -n 10
} > mail.txt

cat mail.txt |mail -s "$DATE Reconciliation" qooweds@163.com
#mail -s "$DATE Reconciliation" qooweds@163.com < mail.txt
