#!/bin/bash


if [ $# -ne 3 ];then
  echo "arguments: template_id(s100) | server_id(s999) | date(20131125)"
  exit
fi

mkdir $2
rsync -av --port=8733 --exclude=".svn" $1/* $2

CONFIG_FILE="list.csv"
ARR_SERVER_ID=($(awk 'BEGIN{FS=","}{print $1}' $CONFIG_FILE))
ARR_PLATFORM_SERVER_ID=($(awk 'BEGIN{FS=","}{print $2}' $CONFIG_FILE))
ARR_SERVER_IP=($(awk 'BEGIN{FS=","}{print $3}' $CONFIG_FILE))
ARR_SERVER_PATH=($(awk 'BEGIN{FS=","}{print $4}' $CONFIG_FILE))
ARR_DB_NAME=($(awk 'BEGIN{FS=","}{print $5}' $CONFIG_FILE))
ARR_DB_IP=($(awk 'BEGIN{FS=","}{print $6}' $CONFIG_FILE))
ARR_DB_PORT=($(awk 'BEGIN{FS=","}{print $8}' $CONFIG_FILE))
ARR_SEQ_IN_SERVER=($(awk 'BEGIN{FS=","}{print $12}' $CONFIG_FILE))

for((i=1;i<${#ARR_SERVER_ID[@]};i++))
do
  if [ "$2" == "${ARR_SERVER_ID[i]}" ];then 
  server_id=`echo "$2"|tr -d "s"`
  seq_num=${ARR_SEQ_IN_SERVER[i]}
  log_server_port=`expr $seq_num \* 100 + 2005`
  zone_server_port=`expr $seq_num \* 100 + 2004`
  gate_server_port=`expr $seq_num \* 100 + 2001`
  name_server_port=`expr $seq_num \* 100 + 2002`
  datastore_port=`expr $seq_num \* 100 + 2007`
  fight_web_server_port=`expr $seq_num \* 100 + 2003`
  gm_logic_port=`expr $seq_num \* 100 + 2008`
  gm_name_port=`expr $seq_num \* 100 + 2009`
  gate_client_port=`expr $seq_num \* 100 + 2006`
  db_ip="${ARR_DB_IP[i]}"
  db_port="${ARR_DB_PORT[i]}"

  xml_file="s$server_id/update_xml.py"
  
echo $log_server_port
echo $zone_server_port

  sed -ri "s/^server_id.*/server_id = \"$server_id\"/ " $xml_file
  sed -ri "s/^server_list.*//" $xml_file

  sed -ri "s/^log_server_port.*/log_server_port = \"$log_server_port\"/ " $xml_file
  sed -ri "s/^zone_server_port.*/zone_server_port = \"$zone_server_port\"/ " $xml_file
  sed -ri "s/^gate_server_port.*/gate_server_port = \"$gate_server_port\"/ " $xml_file
  sed -ri "s/^name_server_port.*/name_server_port = \"$name_server_port\"/ " $xml_file
  sed -ri "s/^datastore_port.*/datastore_port = \"$datastore_port\"/ " $xml_file
  sed -ri "s/^fight_web_server_port.*/fight_web_server_port = \"$fight_web_server_port\"/ " $xml_file
  sed -ri "s/^gm_logic_port.*/gm_logic_port = \"$gm_logic_port\"/ " $xml_file
  sed -ri "s/^gm_name_port.*/gm_name_port = \"$gm_name_port\"/ " $xml_file
  sed -ri "s/^gate_client_port.*/gate_client_port = \"$gate_client_port\"/ " $xml_file

  sed -ri "s/^db_server.*/db_server = \"$db_ip\"/ " $xml_file
  sed -ri "s/^db_port.*/db_port = \"$db_port\"/ " $xml_file
  sed -ri "s/^db_name.*/db_name = \"shengbei_lianyun_s$server_id\"/ " $xml_file

  sed -ri "s/^logic_server_id_generate_begin.*/logic_server_id_generate_begin = \"${server_id}000000\"/ " $xml_file
  sed -ri "s/^logic_startup_begin_sec.*/logic_startup_begin_sec = \"$3 00:00:00\"/ " $xml_file
  sed -ri "s/^logic_startup_end_sec.*/logic_startup_end_sec = \"$3 00:00:00\"/ " $xml_file

  
  ./update_server_config.py s$server_id/update_xml.py $1 s$server_id
  rsync -av --port=8733 --exclude=".svn" s$server_id kingnet@192.168.110.154::data/tools/
#  rsync -av --port=8733 --exclude=".svn" s$server_id kingnet@210.65.163.28::data/tools/
  ssh kingnet@192.168.110.154 "/usr/bin/rsync -av --port=8733 /data/tools/s$server_id kingnet@192.168.7.205::data/tools/"
  break
  fi
done

