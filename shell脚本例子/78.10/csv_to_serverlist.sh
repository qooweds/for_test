#!/bin/bash

CONFIG_FILE="list.csv"
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

  echo $server_id
  if [ `cat pubtools/server_list.py |grep ${server_id} |wc -l` -gt 0 ];then
done
