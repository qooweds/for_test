#!/bin/bash
cat list_uc.csv |grep -Ev "4game|transit" > list_uc_monitor.csv
rsync -av --port=8733 ./list_uc_monitor.csv kingnet@42.62.56.227::data/remote_server_ctl/list_uc_monitor.csv

cat list_zhongshan.csv |grep -Ev "fb|transit" > list_zhongshan_monitor.csv
rsync -av --port=8733 ./list_zhongshan_monitor.csv kingnet@192.168.110.154::data/remote_server_ctl/list_zhongshan_monitor.csv

rsync -av --port=8733 ./list_4game.csv kingnet@203.90.239.60::data/remote_server_ctl/list_4game_monitor.csv
