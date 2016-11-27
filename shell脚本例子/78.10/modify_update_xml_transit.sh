#!/bin/bash

cat list_zhongshan.csv |grep -Ev "sina|fb|4game" |grep running |grep -v transit | awk -F, '{print $1}' > zhongshan_server.txt
cat list_uc.csv |grep -Ev "fb|4game" |grep running |grep -v transit | awk -F, '{print $1}' > uc_server.txt

cat uc_server.txt |while read server_id
do 
  sed -i "6 r uc_insert.txt" $server_id/update_xml.py
./update_transit_config.py $server_id/update_xml.py s6 $server_id
./pubtools/batch_sync.py $server_id $server_id
done

cat zhongshan_server.txt |while read server_id
do
  sed -i "6 r zhongshan_insert.txt" $server_id/update_xml.py
./update_transit_config.py $server_id/update_xml.py s6 $server_id
./pubtools/batch_sync.py $server_id $server_id
done
