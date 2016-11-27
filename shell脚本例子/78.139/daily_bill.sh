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
    echo
#    echo "In the past hour,in server $SERVER_ID:" >> lic_currency.txt
#    if [ $(date '+%H') = 00 ] ; then
#    {
#    echo 
#    awk '{FS="|"} /GOLD_COIN/&&/ADD_MONEY/&&/'"$HOUR"'/ {goldadd_sum+=$10} END {print "coin add in server last hour: "goldadd_sum}' $SRC_PATH/$MONEY_LOG
#    awk '{FS="|"} /GOLD_COIN/&&/SUB_MONEY/&&/'"$HOUR"'/ {goldsub_sum+=$10} END {print "coin sub in server last hour: "goldsub_sum}' $SRC_PATH/$MONEY_LOG
#    awk '{FS="|"} /COUPON/&&/ADD_MONEY/&&/'"$HOUR"'/ {couponadd_sum+=$10} END {print "coupon add in server last hour: "couponadd_sum}' $SRC_PATH/$MONEY_LOG
#    awk '{FS="|"} /COUPON/&&/SUB_MONEY/&&/'"$HOUR"'/ {couponsub_sum+=$10} END {print "coupon sub in server last hour: "couponsub_sum}' $SRC_PATH/$MONEY_LOG
#    awk '{FS="|"} /DIAMOND/&&/ADD_MONEY/&&/'"$HOUR"'/ {diamondadd_sum+=$10} END {print "diamond add in server last hour: "diamondadd_sum}' $SRC_PATH/$MONEY_LOG
#    awk '{FS="|"} /DIAMOND/&&/SUB_MONEY/&&/'"$HOUR"'/ {diamondsub_sum+=$10} END {print "diamond sub in server last hour: "diamondsub_sum}' $SRC_PATH/$MONEY_LOG
#    } >>lic_currency.txt
#    fi
    
    echo     
    {
    echo "Players get more than 30,000,000 coins in last hour:(uid/count)"
    awk '{FS="|"} /ADD_MONEY/&&/GOLD_COIN/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>50000000)print i,arr[i] }' $SRC_PATH/$MONEY_LOG | sort -k2nr -g | head -n 10
    } > log_tmp.txt
    COUNT=`grep -v Player log_tmp.txt |grep -v server |grep -Ev "^#|^$" |wc -l`
    if [[ $COUNT != 0  ]] ;then
        cat log_tmp.txt >>./lic_currency.txt
    fi    

    {
    echo "Players cost more than 30,000,000 coins in last hour:(uid/count)"
    awk '{FS="|"} /SUB_MONEY/&&/GOLD_COIN/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]<-50000000)print i,arr[i]}' $SRC_PATH/$MONEY_LOG | sort -k2n -g | head -n 10
    } > log_tmp.txt
    COUNT=`grep -v Player log_tmp.txt |grep -v server |grep -Ev "^#|^$" |wc -l`
    if [[ $COUNT != 0  ]] ;then
        cat log_tmp.txt >>./lic_currency.txt
    fi

    {
    echo "Players get more than 10000 coupon in last hour:(uid/count)"
    awk '{FS="|"} /ADD_MONEY/&&/COUPON/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>10000)print i,arr[i]}' $SRC_PATH/$MONEY_LOG | sort -k2nr -g | head -n 10
    } > log_tmp.txt
    COUNT=`grep -v Player log_tmp.txt |grep -v server |grep -Ev "^#|^$" |wc -l`
    if [[ $COUNT != 0  ]] ;then
        cat log_tmp.txt >>./lic_currency.txt
    fi

    {
    echo "Players cost more than 10000 coupon in last hour:(uid/count)"
    awk '{FS="|"} /SUB_MONEY/&&/COUPON/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>10000)print i,arr[i]}' $SRC_PATH/$MONEY_LOG | sort -k2n -g | head -n 10
    } > log_tmp.txt
    COUNT=`grep -v Player log_tmp.txt |grep -v server |grep -Ev "^#|^$" |wc -l`
    if [[ $COUNT != 0  ]] ;then
        cat log_tmp.txt >>./lic_currency.txt
    fi

    {
    echo "Players get more than 10000 diamond in last hour:(uid/count)"
    awk '{FS="|"} /ADD_MONEY/&&/DIAMOND/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>10000)print i,arr[i]}' $SRC_PATH/$MONEY_LOG | sort -k2nr -g | head -n 10
    } > log_tmp.txt
    COUNT=`grep -v Player log_tmp.txt |grep -v server |grep -Ev "^#|^$" |wc -l`
    if [[ $COUNT != 0  ]] ;then
        cat log_tmp.txt >>./lic_currency.txt
    fi

    {
    echo "Players get more than 10000 diamond in last hour:(uid/count)"
    awk '{FS="|"} /SUB_MONEY/&&/DIAMOND/&&/'"$HOUR"'/ {arr[$3]+=$10}END{for(i in arr) if(arr[i]>10000)print i,arr[i]}' $SRC_PATH/$MONEY_LOG | sort -k2n -g | head -n 10
    } > log_tmp.txt
    COUNT=`grep -v Player log_tmp.txt |grep -v server |grep -Ev "^#|^$" |wc -l`
    if [[ $COUNT != 0  ]] ;then
        cat log_tmp.txt >>./lic_currency.txt
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
#    } >> ./lic_currency.txt
    #${DB_CONN} -e "use $DATABASE;load data local infile   'lic_currency.txt' into table $TABLE fields terminated by '\n';"
done
    
    NUM=`grep -v Player lic_currency.txt |grep -v server |grep -Ev "^#|^$" |wc -l`

#    if [[ "$NUM" != 0 ]] ;then
#        cat lic_currency.txt | mail -s "money change in last hour" lic@kingnet.com lixy@kingnet.com guanl@kingnet.com weitq@kingnet.com guoxl@kingnet.com liucg@kingnet.com
#    fi
#guoxl@kingnet.com weitq@kingnet.com dukf@kingnet.com guanl@kingnet.com 
    rm lic_currency.txt
    rm log_tmp.txt
#    if [ `date "+%H"` -eq 00 ]; then
#        echo yes
#    else
#        echo no
#    fi 
    
