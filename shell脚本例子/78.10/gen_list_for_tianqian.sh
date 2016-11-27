#!/bin/sh

#svn commit list_merge.csv -m "update list_merge.csv"

#for tianqian
cat list_merge.csv |grep -v "merge" |grep -Ev "42.62.|203.90.239." |sed "s/^s*//g" |awk -F"," '{print "s"$1","$2","$3","$10","$5","$6","$8","$9","9000+$1","$12*100+2008","$12*100+2009","$12*100+2003}' > list_for_tianqian_transmit.csv
cat list_merge.csv |grep -v "merge"|grep -E "42.62." |awk -F"," '{print $1","$2","$3","$10","$5","$6","$8","$9","$12*10+2006","$12*10+2008","$12*10+2009","$12*10+2003}' >list_for_tianqian_no_transmit.csv
cat list_for_tianqian_no_transmit.csv |grep -v server >>list_for_tianqian_transmit.csv
sed -i '1s/9000/client/g;1s/2port_seq08/logic/g;1s/2port_seq09/name/g;1s/2port_seq03/fight/g;' list_for_tianqian_transmit.csv
rsync -avp --port=8733 ./list_for_tianqian_transmit.csv kingnet@192.168.78.113:/opt/wwwroot/shb.dev.kingnet.com/www_admin/server_list_merge.csv

mv list_for_tianqian_transmit.csv list_for_tianqian.csv
rm list_for_tianqian_no_transmit.csv
