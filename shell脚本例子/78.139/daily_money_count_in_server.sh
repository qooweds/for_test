#!/bin/sh
DB_CONN="mysql -ugetsb -pdq3adf2t61q -h192.168.110.11 -P3309  "
CONFIG_FILE="/home/kingnet/lic/server.txt"
DATABASE="shb_analyzer"
TABLE="daily_bill"
DATE=$(date -d "-10 day" "+%Y-%m-%d")

cd /opt/app/mysql/bin



