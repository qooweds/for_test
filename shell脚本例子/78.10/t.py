#!/usr/bin/env python
from bs4 import BeautifulSoup
import codecs

from config import *

def open_xml(file_path):
    try:
        file = codecs.open(file_path, mode="r+", encoding="utf-8")
        soup = BeautifulSoup(file)
    except:
        file = codecs.open(file_path, mode="r+", encoding="gbk")
        soup =  BeautifulSoup(file)
    finally:
        return file,soup

def save_xml(file, doc):
    file.seek(0)
    file.truncate()
    file.write(doc.prettify())
    file.close() 


print "update datastore_server"
file,doc = open_xml("datastore_server/datastore_server.xml")
doc.root.ds_acceptor['listen_port'] = datastore_port
doc.root.database['thread'] = logic_database_thread
doc.root.database['host'] = db_server

doc.root.database['port'] = db_port
doc.root.database['user'] = db_user
doc.root.database['password'] = db_password
doc.root.database['dbname'] = db_name
doc.root.database['charset'] = db_charset
save_xml(file,doc)

print "update log_server"
file,doc = open_xml("log_server/log_server.xml")
doc.root.log_listener['listen_port'] = log_server_port
items = doc.root.default_udplog_server.find_all('item')
items[0]['ip'] = default_udp_ip
items[0]['port'] = default_udp_port1 
items[1]['ip'] = default_udp_ip
items[1]['port'] = default_udp_port2
items[2]['ip'] = default_udp_ip 
items[2]['port'] = default_udp_port3
items[3]['ip'] = default_udp_ip
items[3]['port'] = default_udp_port4

items = doc.root.game_udplog_server.find_all('item')
items[0]['ip'] = game_udp_ip
items[0]['port'] = game_udp_port1 
items[1]['ip'] = game_udp_ip
items[1]['port'] = game_udp_port2
items[2]['ip'] = game_udp_ip 
items[2]['port'] = game_udp_port3
items[3]['ip'] = game_udp_ip
items[3]['port'] = game_udp_port4

doc.root.country["name"] = log_country_name
doc.root.platform["name"] = log_platform_name
doc.root.server_id["id"] = server_id


save_xml(file,doc)


print "update logic_server"
file,doc = open_xml("logic_server/logic_server.xml")
doc.root.zone_listener['port'] = zone_server_port
doc.root.gm_listener['port'] = gm_logic_port
doc.root.log_server['port'] = log_server_port
doc.root.database['thread'] = logic_database_thread
doc.root.database['host'] = db_server
doc.root.database['port'] = db_port
doc.root.database['user'] = db_user
doc.root.database['password'] = db_password
doc.root.database['dbname'] = db_name
doc.root.database['charset'] = db_charset

doc.root.cache['max_size'] = logic_cache_max_size
doc.root.cache['inactive_hour'] = logic_cache_inactive_hour
doc.root.timer['app_second'] = logic_timer_app_second
doc.root.timer['delay_second'] = logic_timer_deplay_second
doc.root.timer['save_second'] = logic_timer_save_second
doc.root.server_id['id'] = server_id
doc.root.server_id['id_generate_begin'] = logic_server_id_generate_begin
doc.root.server_id['id_generate_step'] = logic_server_id_generate_step
doc.root.startup['begin_sec'] = logic_startup_begin_sec
doc.root.startup['end_sec'] = logic_startup_end_sec
doc.root.datastore_server["port"] = datastore_port
doc.root.datastore_server["enabled"] = datastore_enabled

save_xml(file,doc)

print "update gate_server"
file,doc = open_xml("gate_server/gate_server.xml")
doc.root.client_acceptor['listen_port'] = gate_client_port
doc.root.server_acceptor['listen_port'] = gate_server_port
#doc.root.web_acceptor['listen_port'] = gate_web_server_port
doc.root.log_server['port'] = log_server_port
doc.root.name_server['port'] = name_server_port
doc.root.token_check['check'] = gate_token_check_check
doc.root.token_check['type'] = gate_token_check_type
doc.root.token_check['key1'] = gate_token_check_key1
doc.root.token_check['key2'] = gate_token_check_key2
doc.root.token_check['valid_duration'] = gate_token_check_valid_duration
doc.root.shutdown["deplay_sec"] = gate_shutdown_deplay_sec
doc.root.message_check["threshold"] = gate_message_check_threshold
doc.root.message_check["seq"] = gate_message_check_seq
doc.root.message_check["heartbeat"] = gate_message_check_heartbeat
doc.root.message_check["active_heartbeat"] =  gate_message_check_active_heartbeat

try:
    server_list
except NameError:
    server_list = [server_id]

try:
    server_list.index(server_id)
except:
    print "ERROR: server_id:%s doesn't in server_list:%s" % (server_id, server_list)
    import sys
    sys.exit(1)

server_id_list = doc.root.server_id_list
server_id_list.clear()
server_id_template = "<server_id id=\"%s\"></server_id>\n"
for id in server_list:
    server_id_list.append(BeautifulSoup(server_id_template % id))

save_xml(file,doc)


print "update zone_server"
file,doc = open_xml("zone_server/zone_server.xml")
doc.root.gate_server['port'] = gate_server_port
doc.root.logic_server['port'] = zone_server_port
doc.root.gm_server['port'] = gm_logic_port
save_xml(file,doc)


print "fight_review_manager.xml"
file,doc = open_xml("zone_server/fight_review_manager.xml")
doc.root.web_listener['port'] = fight_web_server_port
save_xml(file,doc)

print "name_server"
file,doc = open_xml("name_server/name_server.xml")
doc.root.name_acceptor['listen_port'] = name_server_port
doc.root.gm_listener['port'] = gm_name_port
doc.root.log_server['port'] = log_server_port
doc.root.database['thread'] = name_database_thread
doc.root.database['host'] = db_server
doc.root.database['port'] = db_port
doc.root.database['user'] = db_user
doc.root.database['password'] = db_password
doc.root.database['dbname'] = db_name
doc.root.database['charset'] = db_charset
save_xml(file,doc)

 
