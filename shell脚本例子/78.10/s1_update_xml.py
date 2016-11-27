#!/usr/bin/env python
from bs4 import BeautifulSoup
import codecs

server_id = "1"

transit_server_port="2301"
is_transit_server="false"
is_transit_open="true"

log_server_port = "2105"
zone_server_port= "2104"
fight_web_server_port= "2103"
gm_logic_port= "2108"
gm_name_port= "2109"
gate_server_port= "2101"
gate_client_port= "2106"
name_server_port= "2102"
datastore_port= "2107"

datastore_enabled = "0"

default_udp_ip = "192.168.85.13"
default_udp_port1 = "8020"
default_udp_port2 = "8021"
default_udp_port3 = "8022"
default_udp_port4 = "8023"

game_udp_ip = "192.168.85.13"
game_udp_port1 = "8030"
game_udp_port2 = "8031"
game_udp_port3 = "8032"
game_udp_port4 = "8033"

db_server = "192.168.78.136"
db_port = "3306"
db_user = "root"
db_password = ""
db_name = "transition_s1"
db_charset = "utf8"

#cfg for logic_server
logic_database_thread = "8"
logic_cache_max_size = "1000000"
logic_cache_inactive_hour = "24"
logic_timer_app_second="60"
logic_timer_deplay_second="10"
logic_timer_save_second="30"
#logic_server_id
logic_server_id_generate_begin="1000000"
logic_server_id_generate_step = "100"
logic_startup_begin_sec = "20130820 00:00:00"
logic_startup_end_sec = "20130808 23:59:59"


#cfg for gate_server
gate_token_check_check = "false"
gate_token_check_type = "1"
gate_token_check_key1 = "test"
gate_token_check_key2 = "not used"
gate_token_check_valid_duration = "600"
gate_shutdown_deplay_sec = "30"
gate_message_check_threshold = "true"
gate_message_check_seq = "true"
gate_message_check_heartbeat = "true"
gate_message_check_active_heartbeat = "true"
#gate_server_id

#cfg for name_server
name_database_thread = 1

#cfg for log_server
log_country_name = "cn"
log_platform_name = "sina"

