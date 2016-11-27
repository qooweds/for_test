#/bin/bash

CONFIG_FILE="removal_server.csv"
arr_num=($(awk '{print $1}' $CONFIG_FILE))
arr_old_ip=($(awk '{print $2}' $CONFIG_FILE))
arr_new_ip=($(awk '{print $3}' $CONFIG_FILE))

for((i=0;i<${#arr_num[@]};i++))
do
  old_ip=${arr_old_ip[i]}
  new_ip=${arr_new_ip[i]}

sed -i "s/$old_ip/$new_ip/g" list.csv
done
