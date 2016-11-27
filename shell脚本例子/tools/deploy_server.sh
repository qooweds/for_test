#!/bin/bash
if [ $# -ne 2 ];then
  echo "arguments: version(v34) | server_id(s999)"
  exit
fi

python ./pubtools/batch_sync.py $1 $2
sh ./create_new_database.sh $2
sh ./add_generate_rank.sh $2
sh ./server_remote_start.sh start $2
