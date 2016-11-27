#!/bin/bash
if [ $# -ne 1 ] ;then
  echo "need 1 arguments for template:"
  exit
fi

cat list_for_tianqian.csv |grep $1 |awk -F, '{print "s0.lianyun.sheng.xy.com:"$9" --> "$3":"$10-2}' 
