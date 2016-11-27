#!/bin/bash
CONFIG_FILE="list_uc.csv"
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
  server_id=`echo "${ARR_SERVER_ID[i]}"|tr -d "s"`
  log_server_port="2${ARR_SEQ_IN_SERVER[i]}5"
  zone_server_port="2${ARR_SEQ_IN_SERVER[i]}4"
  gate_server_port="2${ARR_SEQ_IN_SERVER[i]}1"
  name_server_port="2${ARR_SEQ_IN_SERVER[i]}2"
  datastore_port="2${ARR_SEQ_IN_SERVER[i]}7"
  fight_web_server_port="2${ARR_SEQ_IN_SERVER[i]}3"
  gm_logic_port="2${ARR_SEQ_IN_SERVER[i]}8"
  gm_name_port="2${ARR_SEQ_IN_SERVER[i]}9"
  gate_client_port="2${ARR_SEQ_IN_SERVER[i]}6"
  db_ip="${ARR_DB_IP[i]}"
  db_port="${ARR_DB_PORT[i]}"

  xml_file="s$server_id/update_xml.py"
  
echo $xml_file
  sed -ri "s/^server_id.*/server_id = \"$server_id\"/ " $xml_file

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
#  sed -ri "s/^db_name.*/db_name = \"shengbei_lianyun_s$server_id\"/ " $xml_file

#  sed -ri "s/^logic_server_id_generate_begin.*/logic_server_id_generate_begin = \"${server_id}000000\"/ " $xml_file
#  sed -ri "s/^logic_startup_begin_sec.*/logic_startup_begin_sec = \"$3 00:00:00\"/ " $xml_file
#  sed -ri "s/^logic_startup_end_sec.*/logic_startup_end_sec = \"$3 00:00:00\"/ " $xml_file

  
  ./update_transit_config.py s$server_id/update_xml.py $1 s$server_id
  ./pubtools/batch_sync.py s$server_id s$server_id  
done

