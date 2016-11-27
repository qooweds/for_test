#!/bin/env python
#-*- coding: utf-8 -*- 

import sys,os
import struct
import time,datetime
import string
from xml.dom.minidom import *

import subprocess 

import _mysql as database

reload(sys)
sys.setdefaultencoding('utf8')

def get_redo_sql(time_str,bill_file):
    cmd= "grep '%s' %s | awk -F'#' '{if($2 <1) print $3}' " %(time_str,bill_file)
    print cmd
    try:
        result = subprocess.check_output(cmd,shell=True)
    except subprocess.CalledProcessError:
        return False
    except Exception as ex :
        print ex
        exit(1)

    return result

def get_config_value(doc,tag_name,attr_name):
    for node in doc.getElementsByTagName(tag_name):
        return node.getAttribute(attr_name)

    return False

def batch_execute_sql(dbconn,sql_list):
    for record in sql_list :
        try:
            print record 
            dbconn.query(record)
        except Exception as ex:
            print ex



def main(config_file):
    xml_config = parse(config_file)
    db_host=get_config_value(xml_config,"database","host")
    db_port=int(get_config_value(xml_config,"database","port"))
    db_user=get_config_value(xml_config,"database","user")
    db_password=get_config_value(xml_config,"database","password")
    db_charset=get_config_value(xml_config,"database","charset")
    db_name=get_config_value(xml_config,"database","dbname")
    if db_host == False or db_port == False or db_name == False  :
        print "missing database config"
        exit(1)

    last_hour_time = time.localtime(time.time() - 3600 )

    sql_data = get_redo_sql(time.strftime("%Y-%m-%d %H:",last_hour_time),time.strftime("../logic_server/sql_bill-%Y-%m-%d.log",last_hour_time) )

    if len(sql_data ) < 1 :
        exit(0)

    dbconn=database.connect(host=db_host,port=db_port,user=db_user,passwd=db_password,db=db_name,connect_timeout=5)
    dbconn.set_character_set(db_charset)

    sql_list = sql_data.split(";")
    batch_execute_sql(dbconn,sql_list)

    dbconn.close()
   
if __name__ == "__main__":
    config_file = "../logic_server/logic_server.xml"
    if len(sys.argv) >1 :
        config_file = sys.argv[1]

    file_dir=os.path.dirname(os.path.abspath(sys.argv[0]))
    os.chdir(file_dir)
    print os.getcwd()

    try:
        main(config_file)
    except BaseException as e:
        print e
