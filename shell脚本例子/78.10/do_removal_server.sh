#!/bin/bash

#	  cp list.csv.bak list.csv
#	  cp pubtools/server_list.py.bak pubtools/server_list.py
          cp list.csv.bak list_test.csv 
	  sh modify_ip.sh
	  
#	  cat list_test.csv |grep -Ev "transit|merge|192.168|4game" |awk -F, '{print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","++arr[$3]}' >list_tmp.csv
#	  cat list_test.csv |grep -E "transit|merge|192.168|4game" >list_merge.csv
#	  cat list_tmp.csv >>list_merge.csv
          sh modify_port.sh
          sh batch_gen_update_xml_file.sh s6
          sh cut_list.sh
