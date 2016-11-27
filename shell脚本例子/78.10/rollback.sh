#!/bin/bash

if [ $# -ne 1 ];then
  echo "Please input template_sid:"
  exit
fi

for((i=179;i<=179;i++))
do
  cp /opt/shengbei_operation/backup/backup_20140401/update_xml_s$i.py /opt/shengbei_operation/xy/s$i/update_xml.py
echo "copy /opt/shengbei_operation/backup/backup_20140401/update_xml_s$i.py /opt/shengbei_operation/xy/s$i/update_xml.py"
  
  echo s$i
   ./update_server_config_transit.py s$i/update_xml.py $1 s$i

   ./pubtools/batch_sync.py s$i s$i

done
