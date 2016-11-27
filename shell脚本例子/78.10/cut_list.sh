#!/bin/sh

#svn commit list.csv -m "update list.csv"

#for tianqian
cat list.csv |grep -v "merge" |grep -Ev "42.62.|203.90.239." |sed "s/^s*//g" |awk -F"," '{print "s"$1","$2","$3","$10","$5","$6","$8","$9","9000+$1","$12*100+2008","$12*100+2009","$12*100+2003}' > list_for_tianqian_transmit.csv
cat list.csv |grep -v "merge"|grep -E "42.62." |awk -F"," '{print $1","$2","$3","$10","$5","$6","$8","$9","$12*10+2006","$12*10+2008","$12*10+2009","$12*10+2003}' >list_for_tianqian_no_transmit.csv
cat list_for_tianqian_no_transmit.csv |grep -v server >>list_for_tianqian_transmit.csv
sed -i '1s/9000/client/g;1s/2port_seq08/logic/g;1s/2port_seq09/name/g;1s/2port_seq03/fight/g;' list_for_tianqian_transmit.csv
rsync -avp --port=8733 ./list_for_tianqian_transmit.csv kingnet@192.168.78.113:/opt/wwwroot/shb.dev.kingnet.com/www_admin/server_list.csv

mv list_for_tianqian_transmit.csv list_for_tianqian.csv
rm list_for_tianqian_no_transmit.csv

#zhongshan
cat list.csv |grep -E "sina|server|2144_s|gtv|7k7k|51_s|fb_s" |grep -Ev "merge|closed" >./list_zhongshan.csv
cat list_zhongshan.csv |grep -Ev "data/xy/shengbei_s6_9006|data/xy/shengbei_s7_9007|fb_s" >list_zhongshan_other.csv

#UC
cat list.csv |grep -Ev "sina|2144_s|gtv|7k7k|51_s|fb_s|4game" |grep -Ev "merge|closed" >list_uc.csv
cat list_uc.csv |grep -Ev "360_s|4399_s" >list_uc_other.csv
cat list_uc.csv |grep -E "server|360_s|4399_s" >list_360_4399.csv

#4game
#cat list.csv |grep -E "4game|server" >list_4game.csv

#fb
#cat list.csv |grep -E "fb|server" > list_fb.csv

#server_list.py
cat pubtools/server_list.py |grep -Ev "42.62.|203.90.|192.168.7.|10.8." > zhongshan_server_list.py
cat pubtools/server_list.py |grep -Ev "192.168.|203.90." > uc_server_list.py
#cat pubtools/server_list.py |grep -Ev "42.62.|192.168." > 4game_server_list.py
#cat pubtools/server_list.py |grep -Ev "42.62.|192.168.110|10.8." > fb_server_list.py


rsync -avp --port=8733 ./list_uc.csv kingnet@42.62.56.227::data/remote_server_ctl/
rsync -avp --port=8733 ./list_uc_other.csv kingnet@42.62.56.227::data/remote_server_ctl/
rsync -avp --port=8733 ./list_360_4399.csv kingnet@42.62.56.227::data/remote_server_ctl/
rsync -avp --port=8733 ./list_uc.csv kingnet@42.62.56.227::data/tools/

rsync -avp --port=8733 ./list_zhongshan.csv kingnet@192.168.110.154::data/remote_server_ctl/
rsync -avp --port=8733 ./list_zhongshan.csv kingnet@192.168.110.154::data/tools/
rsync -avp --port=8733 ./list_zhongshan_other.csv kingnet@192.168.110.154::data/remote_server_ctl/

#rsync -avp --port=8733 ./list_fb.csv kingnet@kingnet@192.168.110.154::data/tools/
#ssh kingnet@192.168.110.154 "/usr/bin/rsync -avp --port=8733 /data/tools/list_fb.csv kingnet@192.168.7.205::data/tools/"

CONFIG_FILE="list_uc.csv"
ARR_SERVER_ID=($(awk 'BEGIN{FS=","}{print $1}' $CONFIG_FILE))
ARR_INNER_IP=($(awk 'BEGIN{FS=","}{print $3}' $CONFIG_FILE))
ARR_OUTER_IP=($(awk 'BEGIN{FS=","}{print $10}' $CONFIG_FILE))
ARR_SERVER_PATH=($(awk 'BEGIN{FS=","}{print $4}' $CONFIG_FILE))

for((i=1;i<${#ARR_SERVER_ID[@]};i++))
do
  server_id=${ARR_SERVER_ID[i]}
  inner_ip=${ARR_INNER_IP[i]}
  outer_ip=${ARR_OUTER_IP[i]}
  server_path=${ARR_SERVER_PATH[i]}

#  echo $server_id
  sed -i "s/$outer_ip/$inner_ip/g" uc_server_list.py

done

#rsync -avp --port=8733 ./list_4game.csv kingnet@203.90.239.60::data/tools/
#rsync -avp --port=8733 ./list_4game.csv kingnet@203.90.239.60::data/remote_server_ctl/

rsync -avp --port=8733 ./zhongshan_server_list.py kingnet@192.168.110.154::data/tools/pubtools/server_list.py
rsync -avp --port=8733 ./uc_server_list.py kingnet@42.62.56.227::data/tools/pubtools/server_list.py

#sed -i "s/203.90.239.60/10.8.3.27/g" 4game_server_list.py
#rsync -avp --port=8733 ./4game_server_list.py kingnet@203.90.239.60::data/tools/pubtools/server_list.py

#rsync -avp --port=8733 ./fb_server_list.py kingnet@192.168.110.154::data/tools/pubtools/fb_server_list.py
#ssh kingnet@192.168.110.154 "/usr/bin/rsync -avp --port=8733 /data/tools/pubtools/fb_server_list.py kingnet@192.168.7.205::data/tools/pubtools/server_list.py"
#ssh kingnet@192.168.110.154 "/usr/bin/rsync -avp --port=8733 /data/tools/list_fb.csv kingnet@192.168.7.205::data/remote_server_ctl/list_fb.csv"
