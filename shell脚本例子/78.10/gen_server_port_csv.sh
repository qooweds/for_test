#!/bin/bash

CONFIG_FILE="list_test.csv"












for((i=1;i<2;i++));do echo "s$i,3"
cat list.csv |awk -F"," '{print $1","$2","$3","$10","$5","$6","$8","$9}' >list_for_tianqian.csv
