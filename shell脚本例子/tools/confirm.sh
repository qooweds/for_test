#!/bin/sh

begin=4
end=420

#if [ $# -ne 1 ] ;then
#  echo "need 1 arguments for template."
#  exit
#fi



while [ $begin -le $end  ]
do
  echo $begin
  echo "./pubtools/batch_sync_version.py $1 s$begin"
  ./pubtools/batch_sync_version.py $1 s$begin 

  let begin=1+begin
done
