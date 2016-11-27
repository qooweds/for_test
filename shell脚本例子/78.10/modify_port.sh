#!/bin/bash

          cat list_test.csv |grep -Ev "transit|merge|192.168|4game" |awk -F, '{print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","++arr[$3]}' >list_tmp.csv
          cat list_test.csv |grep -E "transit|merge|192.168|4game" >list_merge.csv

          cat list_tmp.csv |awk -F, '{if($12<10){print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11",0"$12}else{print $0}}' >>list_merge.csv
          cat list_merge.csv |grep -Ev "transit|merge|192.168|4game" >list_modify.csv
          cp list_merge.csv list.csv
