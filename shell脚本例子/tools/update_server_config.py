#!/usr/bin/env python
from bs4 import BeautifulSoup
import codecs
import sys,os

wan_bind_ip="0.0.0.0"
lan_bind_ip="0.0.0.0"
log_level="3"
log_server_log_level="4"

delay_sec="5" 
online_threshold="5000"

server_list=[]


def open_xml(file_path):
   
    file = codecs.open(file_path, mode="r", encoding="utf-8")
    soup = BeautifulSoup(file)
    file.close()
    return soup

def save_xml(file_path, doc):
    path = os.path.dirname(file_path)
    if not os.path.exists(path) :
        os.makedirs(path)
    file = codecs.open(file_path, mode="w", encoding="utf-8")
    file.write(doc.prettify())
    file.close() 





def generate_datastore_config():
    datastore_file="/datastore_server/datastore_server.xml" ;
    doc = open_xml(src_dir + datastore_file)
    doc.root.log['level'] = log_level 
    doc.root.ds_acceptor['listen_port'] = datastore_port
    doc.root.database['thread'] = logic_database_thread
    doc.root.database['host'] = db_server

    doc.root.database['port'] = db_port
    doc.root.database['user'] = db_user
    doc.root.database['password'] = db_password
    doc.root.database['dbname'] = db_name
    doc.root.database['charset'] = db_charset

    save_xml(dst_dir + datastore_file,doc)


def generate_log_config():
    log_file="/log_server/log_server.xml"
    doc = open_xml(src_dir + log_file )
    doc.root.log['level'] = log_server_log_level 
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

    save_xml(dst_dir + log_file,doc)


def generate_logic_config():
    logic_file="/logic_server/logic_server.xml"
    doc = open_xml(src_dir + logic_file )

    doc.root.log['level'] = log_level 
    doc.root.zone_listener['port'] = zone_server_port
    doc.root.gm_listener['ip'] = lan_bind_ip 
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

    save_xml(dst_dir + logic_file,doc)


def generate_gate_config():
    gate_file="/gate_server/gate_server.xml"
    doc = open_xml(src_dir + gate_file )

    doc.root.log['level'] = log_level 
    doc.root.shutdown['delay_sec'] =delay_sec 
	
    doc.root.client_acceptor['listen_port'] = gate_client_port
    doc.root.client_acceptor['online_threshold'] =online_threshold 
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
    
    #server_list = merge_server_id.split(",")
    server_list.append( server_id )



    server_id_list = doc.root.server_id_list
    server_id_list.clear()
    server_id_template = "<server_id id=\"%s\"></server_id>\n"
    for id in server_list:
        server_id_list.append(BeautifulSoup(server_id_template % id))
    
    save_xml(dst_dir + gate_file,doc)


def generate_zone_config():
    zone_file="/zone_server/zone_server.xml"
    doc = open_xml(src_dir + zone_file )

    doc.root.log['level'] = log_level 
    doc.root.gate_server['port'] = gate_server_port
    doc.root.logic_server['port'] = zone_server_port
    doc.root.gm_server['port'] = gm_logic_port
    doc.root.gm_server['ip'] = lan_bind_ip 
    
    save_xml(dst_dir + zone_file,doc)


def generate_fight_review_config():
    fight_review_file="/zone_server/fight_review_manager.xml"
    doc = open_xml(src_dir + fight_review_file )

    doc.root.web_listener['port'] = fight_web_server_port
    doc.root.web_listener['ip'] = wan_bind_ip

    save_xml(dst_dir + fight_review_file,doc)

def generate_name_config():
    name_file="/name_server/name_server.xml"
    doc = open_xml(src_dir + name_file )

    doc.root.log['level'] = log_level 
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

    save_xml(dst_dir + name_file,doc)

 
def generate_gm_config():
    gm_file="/gm/rank.xml"
    doc = open_xml(src_dir + gm_file )

    doc.root.gm_server['port'] = gm_logic_port
    doc.root.database['thread'] = name_database_thread
    doc.root.database['host'] = db_server
    doc.root.database['port'] = db_port
    doc.root.database['user'] = db_user
    doc.root.database['password'] = db_password
    doc.root.database['dbname'] = db_name
    doc.root.database['charset'] = db_charset
    doc.root.local_rank_file['path'] = local_rank_file_path
    doc.root.remote_rank_file['path'] = remote_rank_file_path 
    doc.root.sync_command['path'] = sync_command_path

    save_xml(dst_dir + gm_file,doc)


def test():
    print gate_token_check_check
    print sync_command_path

src_dir="./"
dst_dir="./"

if __name__ == "__main__" :
    if len(sys.argv) < 4 :
        print "usage:%s python_config_file src_dir dst_dir" % sys.argv[0]
        exit(1)
    config_file = sys.argv[1]
    execfile(config_file)

    #sys.path.append(os.path.dirname(config_file) )
    #file_name,file_ext = os.path.splitext(config_file)
    #__import__(file_name,fromlist=["*"])
    #exec config_file   

    src_dir=sys.argv[2]
    dst_dir=sys.argv[3]
    

    generate_datastore_config()
    generate_log_config()
    generate_logic_config()
    generate_gate_config()
    generate_zone_config()
    generate_fight_review_config()
    generate_name_config()
    #generate_gm_config()  
   
