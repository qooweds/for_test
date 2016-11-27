#/bin/bash

CONFIG_FILE="removal_server.csv"
arr_num=($(awk '{print $1}' $CONFIG_FILE))
arr_old_outer_ip=($(awk '{print $2}' $CONFIG_FILE))
arr_old_inner_ip=($(awk '{print $3}' $CONFIG_FILE))
arr_new_outer_ip=($(awk '{print $4}' $CONFIG_FILE))
arr_new_inner_ip=($(awk '{print $5}' $CONFIG_FILE))

for((i=0;i<${#arr_num[@]};i++))
do
  old_outer_ip=${arr_old_outer_ip[i]}
  old_inner_ip=${arr_old_inner_ip[i]}
  new_outer_ip=${arr_new_outer_ip[i]}
  new_inner_ip=${arr_new_inner_ip[i]}

sed -i "s/$old_outer_ip/$new_outer_ip/g" list_test.csv
sed -i "s/$old_inner_ip/$new_inner_ip/g" list_test.csv
sed -i "s/$old_outer_ip/$new_outer_ip/g" pubtools/server_list.py
done
