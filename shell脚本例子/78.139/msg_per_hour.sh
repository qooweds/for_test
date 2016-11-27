#!/bin/bash
#new use the file "account_check.sh",this file is not useful

DB_CONN="mysql -uroot -h192.168.78.139"
CONFIG_FILE="/home/kingnet/lic/server.txt"
DATABASE="shb_analyzer"
TABLE="daily_bill"
HOUR=`date -d "-1 hour" "+%Y-%m-%d %H:"`

MONEY_LOG=$(date -d "-0 day" "+money-%Y-%m-%d.log")

if [ $(date '+%H') = 00 ] ; then
   MONEY_LOG=$(date -d "-1 day" "+money-%Y-%m-%d.log")
fi

ARR_SERVER_ID=($(awk '{print $1}' $CONFIG_FILE))
ARR_SRC_PATH=($(awk '{print $3}' $CONFIG_FILE))

for((i=0;i<${#ARR_SERVER_ID[@]};i++))
do
    SERVER_ID=${ARR_SERVER_ID[i]}
    SRC_PATH=${ARR_SRC_PATH[i]}
#    {     
    {
    awk '{FS="|"} /ADD_MONEY/&&/GOLD_COIN/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>100000000)print i,arr[i],"(Sina:get coin)" }' $SRC_PATH/$MONEY_LOG | sort -k2nr -g | head -n 10
    } > log_msg_tmp.txt
    COUNT=`grep -v Player log_msg_tmp.txt |grep -v server |grep -Ev "^#|^$" |wc -l`
    if [[ $COUNT != 0  ]] ;then
        cat log_msg_tmp.txt >>./lic_msg.txt
    fi    

    {
    awk '{FS="|"} /SUB_MONEY/&&/GOLD_COIN/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>100000000)print i,arr[i],"(Sina:cost coin)" }' $SRC_PATH/$MONEY_LOG | sort -k2n -g | head -n 10
    } > log_msg_tmp.txt
    COUNT=`grep -v Player log_msg_tmp.txt |grep -v server |grep -Ev "^#|^$" |wc -l`
    if [[ $COUNT != 0  ]] ;then
        cat log_msg_tmp.txt >>./lic_msg.txt
    fi

    {
    awk '{FS="|"} /ADD_MONEY/&&/COUPON/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>100000)print i,arr[i],"(Sina:get coupon)" }' $SRC_PATH/$MONEY_LOG | sort -k2nr -g | head -n 10
    } > log_msg_tmp.txt
    COUNT=`grep -v Player log_msg_tmp.txt |grep -v server |grep -Ev "^#|^$" |wc -l`
    if [[ $COUNT != 0  ]] ;then
        cat log_msg_tmp.txt >>./lic_msg.txt
    fi

    {
    awk '{FS="|"} /SUB_MONEY/&&/COUPON/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>100000)print i,arr[i],"(Sina:cost coupon)" }' $SRC_PATH/$MONEY_LOG | sort -k2n -g | head -n 10
    } > log_msg_tmp.txt
    COUNT=`grep -v Player log_msg_tmp.txt |grep -v server |grep -Ev "^#|^$" |wc -l`
    if [[ $COUNT != 0  ]] ;then
        cat log_msg_tmp.txt >>./lic_msg.txt
    fi

    {
    awk '{FS="|"} /ADD_MONEY/&&/DIAMOND/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>100000)print i,arr[i],"(Sina:get diamond)" }' $SRC_PATH/$MONEY_LOG | sort -k2nr -g | head -n 10
    } > log_msg_tmp.txt
    COUNT=`grep -v Player log_msg_tmp.txt |grep -v server |grep -Ev "^#|^$" |wc -l`
    if [[ $COUNT != 0  ]] ;then
        cat log_msg_tmp.txt >>./lic_msg.txt
    fi

    {
    awk '{FS="|"} /SUB_MONEY/&&/DIAMOND/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>100000)print i,arr[i],"(Sina:cost diamond)" }' $SRC_PATH/$MONEY_LOG | sort -k2n -g | head -n 10
    } > log_msg_tmp.txt
    COUNT=`grep -v Player log_msg_tmp.txt |grep -v server |grep -Ev "^#|^$" |wc -l`
    if [[ $COUNT != 0  ]] ;then
        cat log_msg_tmp.txt >>./lic_msg.txt
    fi
#    echo "Players cost most coin last hour:(uid/count)"
#    awk '{FS="|"} /SUB_MONEY/&&/GOLD_COIN/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>3000000)print i,arr[i]}' $SRC_PATH/$MONEY_LOG | sort -k2n -g | head -n 10
#    echo "Players get most coupon last hour:(uid/count)"
#    awk '{FS="|"} /ADD_MONEY/&&/COUPON/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>10000)print i,arr[i]}' $SRC_PATH/$MONEY_LOG | sort -k2nr -g | head -n 10
#    echo "Players cost most coupon last hour:(uid/count)"
#    awk '{FS="|"} /SUB_MONEY/&&/COUPON/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>10000)print i,arr[i]}' $SRC_PATH/$MONEY_LOG | sort -k2n -g | head -n 10
#    echo "Players get most diamond last hour:(uid/count)"
#    awk '{FS="|"} /ADD_MONEY/&&/DIAMOND/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>10000)print i,arr[i]}' $SRC_PATH/$MONEY_LOG | sort -k2nr -g | head -n 10
#    echo "Players cost most diamond last hour:(uid/count)"
#    awk '{FS="|"} /SUB_MONEY/&&/DIAMOND/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>10000)print i,arr[i]}' $SRC_PATH/$MONEY_LOG | sort -k2n -g | head -n 10
    echo
#    P_DIAMOND_ADD=$(echo `awk '{FS="|"} /ADD_MONEY/&&/DIAMOND/ {arr[$3]+=$10}END{for(i in arr) print "(",i,":",arr[i],")"}' $SRC_PATH/$MONEY_LOG | sort -k4nr -g | head -n 10`)
#    P_DIAMOND_SUB=$(echo `awk '{FS="|"} /SUB_MONEY/&&/DIAMOND/ {arr[$3]+=$10}END{for(i in arr) print "(",i,":",arr[i],")"}' $SRC_PATH/$MONEY_LOG | sort -k4n -g | head -n 10`)

#    echo $SERVER_ID
#    echo $TIME
#    echo $S_GOLD_ADD
#    echo $S_GOLD_SUB
#    echo $S_COUPON_ADD
#    echo $S_COUPON_SUB
#    echo $S_DIAMOND_ADD
#    echo $S_DIAMOND_SUB
#    echo $P_GOLD_ADD
#    echo $P_GOLD_SUB
#    echo $P_COUPON_ADD
#    echo $P_COUPON_SUB
#    echo $P_DIAMOND_ADD
#    echo $P_DIAMOND_SUB 
#    } >> ./lic_msg.txt
    #${DB_CONN} -e "use $DATABASE;load data local infile   'lic_msg.txt' into table $TABLE fields terminated by '\n';"
done
    
    NUM=`grep -v Player lic_msg.txt |grep -v server |grep -Ev "^#|^$" |wc -l`

    if [[ "$NUM" != 0 ]] ;then
        cat lic_msg.txt | while read LINE
        do    
#            curl -d "tel=15001702933" -d "msg=$LINE" -d "type=3" "http://owl.xy.com/router.php?c=api&a=sendMsg"
#            curl -d "tel=13816050665" -d "msg=$LINE" -d "type=3" "http://owl.xy.com/router.php?c=api&a=sendMsg"
#            curl -d "tel=13764020604" -d "msg=$LINE" -d "type=3" "http://owl.xy.com/router.php?c=api&a=sendMsg"
#            curl -d "tel=18217269686" -d "msg=$LINE" -d "type=3" "http://owl.xy.com/router.php?c=api&a=sendMsg"
        done
    fi

    rm lic_msg.txt
    rm log_msg_tmp.txt
#    if [ `date "+%H"` -eq 00 ]; then
#        echo yes
#    else
#        echo no
#    fi 
    
