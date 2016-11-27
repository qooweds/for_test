#!/bin/env python

import os,sys
import MySQLdb as database

db_list=[
('192.168.78.10',3306,'shengbei_lianyun_s13_test'),
('192.168.78.10',3306,'shengbei_lianyun_s15_test'),
]

def check_db(dbinfo) :
  print "check db [%s:%d] ..." %(dbinfo[0],dbinfo[1])
  conn = database.connect(host=dbinfo[0],port=dbinfo[1],user='root',db=dbinfo[2],connect_timeout=5)
  conn.set_character_set('utf8')

  cur = conn.cursor()

  cur.execute("select role_id,uid,name,gender,tid from role_info limit 10");
  result = cur.fetchall()
  for row in result :
    print "%s | %s | %s | %s | %s " %(row[0],row[1],row[2],row[3],row[4])

  cur.close()

if __name__ == "__main__":
    for db_info in db_list :
        try:
            check_db(db_info)
        except Exception as ex :
            print ex
