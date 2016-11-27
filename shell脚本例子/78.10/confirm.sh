#!/bin/sh

begin=4
end=6

if [ $# -ne 1 ] ;then
  echo "need 1 arguments for template."
  exit
fi

if [ $# -ne 1 ];then
  echo "Please input template_sid:"
  exit
fi

while [ $begin -le $end  ]
do
  if [ $begin -eq 6 ] || [ $begin -eq 7 ] || [ $begin -eq 177 ] || [ $begin -eq 172 ] || [ $begin -eq 201 ]  || [ $begin -eq 202 ] || [ $begin -eq 225 ] || [ $begin -eq 226 ] || [ $begin -eq 227 ] ;then 
    let begin=1+begin
    continue
  fi

  echo $begin
  ./update_transit_config.py s$begin/update_xml.py $1 s$begin
  
  ./pubtools/batch_sync_version.py s$begin s$begin 

  let begin=1+begin
done
